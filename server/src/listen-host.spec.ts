import { listenHost } from './listen-host.js';

describe('listenHost', () => {
  it('keeps the native default on loopback', () => {
    const previous = process.env.BEACON_BIND_HOST;
    delete process.env.BEACON_BIND_HOST;
    try {
      expect(listenHost()).toBe('127.0.0.1');
    } finally {
      if (previous !== undefined) process.env.BEACON_BIND_HOST = previous;
    }
  });
  it('accepts the explicit Docker listener', () => {
    expect(listenHost('0.0.0.0')).toBe('0.0.0.0');
  });
  it.each(['', 'localhost', '::', '192.168.1.1'])('rejects %s', (host) => {
    expect(() => listenHost(host)).toThrow('BEACON_BIND_HOST');
  });
});
