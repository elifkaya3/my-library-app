/*
  Warnings:

  - You are about to drop the column `pastUserId` on the `Book` table. All the data in the column will be lost.
  - You are about to drop the column `presentUserId` on the `Book` table. All the data in the column will be lost.
  - Made the column `name` on table `User` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "Book" DROP CONSTRAINT "Book_pastUserId_fkey";

-- DropForeignKey
ALTER TABLE "Book" DROP CONSTRAINT "Book_presentUserId_fkey";

-- AlterTable
ALTER TABLE "Book" DROP COLUMN "pastUserId",
DROP COLUMN "presentUserId";

-- AlterTable
ALTER TABLE "User" ALTER COLUMN "name" SET NOT NULL;

-- CreateTable
CREATE TABLE "BorrowHistory" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "bookId" INTEGER NOT NULL,
    "userScore" INTEGER NOT NULL,

    CONSTRAINT "BorrowHistory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CurrentBorrowing" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "bookId" INTEGER NOT NULL,

    CONSTRAINT "CurrentBorrowing_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "BorrowHistory" ADD CONSTRAINT "BorrowHistory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BorrowHistory" ADD CONSTRAINT "BorrowHistory_bookId_fkey" FOREIGN KEY ("bookId") REFERENCES "Book"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CurrentBorrowing" ADD CONSTRAINT "CurrentBorrowing_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CurrentBorrowing" ADD CONSTRAINT "CurrentBorrowing_bookId_fkey" FOREIGN KEY ("bookId") REFERENCES "Book"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
