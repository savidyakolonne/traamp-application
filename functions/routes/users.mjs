import admin from "firebase-admin";
import { Router } from "express";

const userRouter = Router();
const auth = admin.auth();
const db = admin.firestore();

// tourist register router
userRouter.post("/register-tourist", async (req, res) => {
  try {
    const createdAt = new Date(req.body.createdAt);
    const uid = db.collection("users").doc().id;
    const { firstName, lastName, email, password, gender, dob, type, country } =
      req.body;
    // create user with firebase auth
    const userRecord = await auth.createUser({
      email,
      password,
    });
    // save to database
    await db.collection("users").doc(uid).set({
      firstName,
      lastName,
      email,
      gender,
      dob,
      type,
      country,
      createdAt,
    });
    // return response
    res.status(201).json({
      msg: "Tourist registered successfully",
    });
  } catch (error) {
    res.status(400).json({
      msg: error.message,
    });
  }
});

// guide register router
userRouter.post("/register-guide", async (req, res) => {
  try {
    const createdAt = new Date(req.body.createdAt);
    const uid = db.collection("users").doc().id;
    const {
      firstName,
      lastName,
      email,
      password,
      gender,
      dob,
      type,
      phoneNumber,
      guideCertificateType,
      certificateNumber,
      nic,
      location,
      address,
      country,
      rating,
      availability,
    } = req.body;
    // create user with firebase auth
    const userRecord = await auth.createUser({
      email,
      password,
    });
    // save to database
    await db.collection("users").doc(uid).set({
      firstName,
      lastName,
      email,
      gender,
      dob,
      type,
      createdAt,
      phoneNumber,
      guideCertificateType,
      certificateNumber,
      nic,
      location,
      address,
      country,
      rating,
      availability,
    });
    // return response
    res.status(201).json({
      msg: "Guide registered successfully",
    });
  } catch (error) {
    res.status(400).json({
      msg: error.message,
    });
  }
});

export default userRouter;
