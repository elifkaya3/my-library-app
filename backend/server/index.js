import express from "express";
import path from "path";
import fs from "fs";
import prisma from "./db.js";
import cors from "cors"

const app = express();
app.use(cors({
  origin: "*"
}))
const port = 8000;

async function getUsers(req, res) {
    const user = await prisma.user.findMany();
      res.json(user);
}
app.get("/users", getUsers);


async function getBooks(req, res) {
    const book = await prisma.book.findMany();
      res.json(book);
}
app.get("/books", getBooks);

app.post('/users/:userId/return/:bookId', async (req, res) => {
  const userId = parseInt(req.params.userId);
  const bookId = parseInt(req.params.bookId);

  if (!bookId) {
    return res.status(400).json({ error: "Book ID is required." });
  }

  try {
    const borrowBook = await prisma.borrowBook.findFirst({
      where: {
        userId: userId,
        bookId: bookId,
        returned: false, // Yeni eklenen alan
      },
    });

    if (!borrowBook) {
      return res.status(404).json({ error: "Book not found or already returned." });
    }

    await prisma.borrowBook.update({
      where: { id: borrowBook.id },
      data: { returned: true },
    });

    res.json({ message: `Book ${bookId} returned by user ${userId}` });
  } catch (error) {
    console.error("Error occurred while returning the book:", error);
    res.status(500).json({ error: "An error occurred while returning the book." });
  }
});



app.get("/users/:id", async (req, res) => {
  const userId = parseInt(req.params.id);

  try {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: {
        currentBorrowing: {
          include: { book: true },
        },
        borrowBook: {
          include: { book: true },
        },
      },
    });

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const presentBooks = user.currentBorrowing.map((borrow) => ({
      id: borrow.book.id,
      name: borrow.book.name,
    }));

    const pastBooks = user.borrowBook.map((history) => ({
      id: history.book.id,
      name: history.book.name,
      userScore: history.userScore,
    }));

    res.json({
      id: user.id,
      name: user.name,
      books: {
        present: presentBooks,
        past: pastBooks,
      },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "An error occurred while fetching the user." });
  }
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});


