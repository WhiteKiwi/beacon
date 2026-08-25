import {
  CanActivate,
  ExecutionContext,
  Injectable,
  NotFoundException,
  OnModuleInit,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { timingSafeEqual } from 'crypto';
import { Request } from 'express';

@Injectable()
export class ReviewAuthGuard implements CanActivate, OnModuleInit {
  private secret = Buffer.alloc(0);

  constructor(private readonly config: ConfigService) {}

  onModuleInit() {
    this.secret = Buffer.from(
      this.config.get<string>('REVIEW_API_SECRET') ?? '',
    );
  }

  canActivate(context: ExecutionContext): boolean {
    const req = context.switchToHttp().getRequest<Request>();
    const auth = req.headers['authorization'] ?? '';
    const token = Buffer.from(auth.startsWith('Bearer ') ? auth.slice(7) : '');

    if (
      this.secret.length === 0 ||
      token.length !== this.secret.length ||
      !timingSafeEqual(token, this.secret)
    ) {
      throw new NotFoundException();
    }

    return true;
  }
}
