import firebaseAdmin from "../config/firebaseAdmin.js";

const { db } = firebaseAdmin;

export const getNotifications = async (req, res) => {
  try {
    const { uid } = req.body;
    const notificationRef = db.collection("notifications");
    const notificationQuery = notificationRef.where("uid", "==", uid);
    const snapshot = await notificationQuery.get();

    const notifications = snapshot.docs.map((doc) => ({
      ...doc.data(),
    }));
    console.log(notifications);

    res.status(200).json({
      msg: "Successfully retrieved notifications",
      notifications: notifications,
    });
  } catch (e) {
    console.log(e);
    res.status(500).json({
      msg: "Error while retrieving data",
    });
  }
};

export const deleteNotifications = async (req, res) => {
  try {
    const { uid } = req.body;

    const snapshot = await db
      .collection("notifications")
      .where("uid", "==", uid)
      .get();

    const batch = db.batch();
    snapshot.forEach((doc) => {
      batch.delete(doc.ref);
    });

    await batch.commit();

    console.log("Successfully deleted notifications.");
    res.status(200).json({
      msg: "Notifications cleared successfully",
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      msg: "Error while deleting notifications",
    });
  }
};

export const updateNotifications = async (req, res) => {
  try {
    const { newNotificationList } = req.body;
    const list = newNotificationList;
    if (list.length > 0) {
      for (let i = 0; i < list.length; i++) {
        const notificationDocRef = db
          .collection("notifications")
          .doc(list[i]["notificationId"]);
        await notificationDocRef.update({ isUnread: false });
        console.log("Updated successfully");
      }
    }

    res.status(200).json({ msg: "Successfully Updated." });
  } catch (e) {
    res.status(400).json({ msg: "Failed to update field." });
  }
};

export const clearNotifications = async (req, res) => {
  try {
    const { notificationList } = req.body;
    const list = notificationList;
    if (list.length > 0) {
      for (let i = 0; list.length; i++) {
        const notificationDocRef = db
          .collection("notifications")
          .doc(list[i]["notificationId"]);

        await notificationDocRef.delete();
        console.log("Notification deleted successfully.");
      }

      res.status(200).json({
        msg: "Notifications removed successfully",
      });
    }
  } catch (error) {
    console.log(error);
    res.status(400).json({
      msg: "Error while removing notification",
    });
  }
};
