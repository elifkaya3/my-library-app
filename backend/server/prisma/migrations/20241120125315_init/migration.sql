/*
  Warnings:

  - You are about to drop the `BorrowHistory` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `CurrentBorrowing` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "BorrowHistory" DROP CONSTRAINT "BorrowHistory_bookId_fkey";

-- DropForeignKey
ALTER TABLE "BorrowHistory" DROP CONSTRAINT "BorrowHistory_userId_fkey";

-- DropForeignKey
ALTER TABLE "CurrentBorrowing" DROP CONSTRAINT "CurrentBorrowing_bookId_fkey";

-- DropForeignKey
ALTER TABLE "CurrentBorrowing" DROP CONSTRAINT "CurrentBorrowing_userId_fkey";

-- AlterTable
ALTER TABLE "Book" ADD COLUMN     "pastUserId" INTEGER,
ADD COLUMN     "presentUserId" INTEGER;

-- AlterTable
ALTER TABLE "User" ALTER COLUMN "name" DROP NOT NULL;

-- DropTable
DROP TABLE "BorrowHistory";

-- DropTable
DROP TABLE "CurrentBorrowing";

-- AddForeignKey
ALTER TABLE "Book" ADD CONSTRAINT "Book_pastUserId_fkey" FOREIGN KEY ("pastUserId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Book" ADD CONSTRAINT "Book_presentUserId_fkey" FOREIGN KEY ("presentUserId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
