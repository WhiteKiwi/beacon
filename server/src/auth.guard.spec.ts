import { ExecutionContext, NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AuthGuard } from './auth.guard.js';

const makeContext = (authorization?: string) =>
  ({
    switchToHttp: () => ({
      getRequest: () => ({ headers: authorization ? { authorization } : {} }),
    }),
  }) as unknown as ExecutionContext;

const makeGuard = (secret: string) => {
  const guard = new AuthGuard({ get: () => secret } as unknown as ConfigService);
  guard.onModuleInit();
  return guard;
};

describe('AuthGuard', () => {
  it('올바른 토큰 → true', () => {
    expect(makeGuard('secret').canActivate(makeContext('Bearer secret'))).toBe(true);
  });

  it('토큰 없음 → 404', () => {
    expect(() => makeGuard('secret').canActivate(makeContext())).toThrow(NotFoundException);
  });

  it('잘못된 토큰 → 404', () => {
    expect(() => makeGuard('secret').canActivate(makeContext('Bearer wrong'))).toThrow(NotFoundException);
  });

  it('Bearer prefix 없음 → 404', () => {
    expect(() => makeGuard('secret').canActivate(makeContext('secret'))).toThrow(NotFoundException);
  });

  it('API_SECRET 미설정 → 404', () => {
    expect(() => makeGuard('').canActivate(makeContext('Bearer secret'))).toThrow(NotFoundException);
  });
});
