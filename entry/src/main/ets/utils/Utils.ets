import { cryptoFramework } from '@kit.CryptoArchitectureKit';

/**
 * Generates a cryptographically secure random floating-point number
 * within the range [min, max).
 *
 * The function uses synchronous crypto-secure random bytes, converts them
 * into a 53-bit normalized floating-point value in the range [0, 1),
 * and then maps that value to the specified range.
 *
 * @param min - The lower bound (inclusive).
 * @param max - The upper bound (exclusive).
 * @returns A secure random number x such that min ≤ x < max.
 */
export function generateSecureRandomNumber(min: number, max: number): number {
  const rand = cryptoFramework.createRandom();
  const len = 8; // 8 bytes (64 bits)
  const randData = rand.generateRandomSync(len);
  const bytes = randData.data;
  let bigIntValue = BigInt(0);
  // Combine all 64 bits into a BigInt
  for (let i = 0; i < 8; i++) {
    bigIntValue = (bigIntValue << BigInt(8)) | BigInt(bytes[i]);
  }
  // Take the upper 53 bits for full floating-point precision
  const maxSafeValue = BigInt(1) << BigInt(53); // 2^53
  const normalized = Number(bigIntValue >> BigInt(11)) / Number(maxSafeValue);
  // Map to [min, max)
  return min + normalized * (max - min);
}