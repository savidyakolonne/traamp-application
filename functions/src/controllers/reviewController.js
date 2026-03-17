import firebaseAdmin from "../config/firebaseAdmin.js";
import admin from "firebase-admin";

const { db } = firebaseAdmin;

export const addReviews = async (req, res) => {
  try {
    const { rating, review, reviewerId, guideId } = req.body;

    // get tourist name using reviewerId
    const userDocRef = await db.collection("users").doc(reviewerId).get();
    const userData = userDocRef.data();
    const reviewerName = userData["firstName"] + " " + userData["lastName"];
    const profPic = userData["profilePicture"];

    // create document for rating
    const reviewDocRef = db.collection("reviews").doc();
    await reviewDocRef.set({
      reviewDocId: reviewDocRef.id,
      rating,
      review,
      guideId,
      reviewerId,
      reviewerName: reviewerName,
      profPic: profPic,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // create collection to store ratings in an array docid == guideId
    const ratingDocRef = db.collection("ratings").doc(guideId);
    const ratingDocSnap = await ratingDocRef.get();

    let ratingsArr = [];

    if (!ratingDocSnap.exists) {
      await ratingDocRef.set({
        ratingId: guideId,
        ratings: [rating],
      });
    } else {
      // get existing ratings array
      const ratingData = ratingDocSnap.data();
      ratingsArr = ratingData.ratings;
      ratingsArr.push(rating);

      await ratingDocRef.update({ ratings: ratingsArr });
    }
    // calculate and update users collection
    let calculationArr = [];
    const ratingDocRefCal = db.collection("ratings").doc(guideId);
    const ratingDocSnapCal = await ratingDocRefCal.get();
    const ratingData = ratingDocSnapCal.data();
    calculationArr = ratingData["ratings"];
    const arrLength = calculationArr.length;
    // calculate total count of ratings
    let sum = 0;
    for (let i = 0; i < calculationArr.length; i++) {
      sum += calculationArr[i];
    }
    // get average rating
    const avgRating = sum / arrLength;

    // update guide document with rating
    const guideDocRef = db.collection("users").doc(guideId);
    await guideDocRef.update({
      rating: avgRating,
    });

    // send response
  } catch (e) {
    console.log(e);
  }
};

export const getReviewsById = async (req, res) => {
  try {
    const { guideId } = req.body;

    const reviewDocRef = db.collection("reviews");
    const reviewQuarry = reviewDocRef.where("guideId", "==", guideId);
    const snapshot = await reviewQuarry.get();
    const reviews = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    console.log(reviews);

    res.status(200).json({
      msg: "Successfully retrieved data.",
      data: reviews,
    });
  } catch (e) {
    console.log(e);
    res.status(400).json({
      msg: "Error while fetching reviews.",
    });
  }
};
