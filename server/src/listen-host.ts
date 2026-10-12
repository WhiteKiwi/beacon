/** Keep native operation on loopback; Docker publishes only a host loopback port. */
export function listenHost(value = process.env.BEACON_BIND_HOST): string {
  if (value === undefined || value === '127.0.0.1') return '127.0.0.1';
  if (value === '0.0.0.0') return value;
  throw new Error('BEACON_BIND_HOST must be 127.0.0.1 or 0.0.0.0');
}
