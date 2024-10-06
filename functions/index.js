const admin = require("firebase-admin");
const functions = require("firebase-functions");

/* eslint-disable max-len */
admin.initializeApp({
  credential: admin.credential.cert({
    type: "service_account",
    project_id: "aircorp-f42be",
    private_key_id: "631ea63e00c132fe23ed3f718f261e9aff733d59",
    private_key:
      "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDZHPvRT7qdRpSI\nvY7DW3676Py12CkwarZdZ3BcGFWWE9ZCGrEHqasmO3ES02hI2fZUGieaMK0+sRi6\nAIxyfcXDSkTHy6+VlZT5Nk1FAgwfJR2qY1Rmj5OcvW0cjwchitkNQsRPqL/VzOf4\nqZ9h8oM8dPCeh1tjIMFEKUma1YmfkSO6l7FXklOSbrx7NMm8bZ+Nggyfi5S0QYrq\n5RqXyKxhxtjMtTOssctrGUPTj18YD7cnfUjPlM73gcxqbpo4F/wYtp+VYSmf6JzV\nMfYAC+RHgHl5wQN4DMqC2pjraoBEFsSW2tXfOkZ1IBkOeU30tkIWzndrtGVdMJPk\nCJcufhRdAgMBAAECggEAJ9j8NcEclseQtN0Xke7dvobHNOfQvXhkcpWsx1ZXBPWs\nlhLYiXfAOALiYKpo4jAQ2AQ53wCOl2pBB8hYfp3rWUmtAH93gSyEPE4VVfRHfcLd\n5DsZTz6MQND6cOqmTCdz6U1nAtjNpqOWMqsNG9i68fJjhDEDGpk1J3mtbuvAt8aA\nkyVr4NJzb68dcsO77CkJmbcwvNUId0mn1SJXE6o2uTMr2uwyKrcRUJjBqazsGihN\nA9UiKDUBBt2rAvQ96UaKQaOV12jEdGQ58fkEjNJ9j6U9P14xsP3u7dL06+AiiEAH\ndxdBGP8Q4/vW/25ct14VPE96E2SzKVQapDkk8zPbmQKBgQD//gMJfKmSuSLtjjev\nSm8Ky4kycIvyaThdOx84LjMZso2tcA9Nk/hVVAaJXp/WhXXvcp/VGTzEZqbowyae\njM3uaakQfEido87WGwdyOGX+TqLWVIQa0hrkUojLJ+wHYTuF/HUrYtUWetYjNWWV\n4L1r8e6T5Qzt0aLnlZfarQB3WQKBgQDZHqt7Pt/1NT/NPzZqQRuUShaN1Fuxi94H\ni9Uj16DbAFtzPnejR59UheH9UybthcurbcwUbOMBUNNbjMc2NqyWu7xeg4wFmV0q\n83YYqi+U/0gWbzbfrGLBU3dF4mrYgOYog44481VGeRboV+KvRyAN0WL2xixlQcT6\nagnkYL1opQKBgB0IqT2FNxJeDxkUXTpzXb7CsO/YlfbLekoQr4zGqKMMfkcig4nP\n84Vx/z/LTKOfBW4/+OLJdvvrjJivsYyf+adFspgdEHtYndfovuJ0hRTfxFY8xbLp\nC4XD2qH4CCwaGg8rP/rIvdRL4EekAb6K+9DnYqDBhMLgWPKdI9j4cCoZAoGBANDp\n5e7M7QowlpeTf3R1+WeScmk+MIyCHL3+GrRGQwz3JweYz91YiUL3ICB05jweRX9K\nQthUfYlCkFzC9NyBd0gClJoM0aqBi1hMsxHAj9A6Ys7TbGWEpfGHsniYCF8SiGPr\nUeoSmbcZxKUEC6bENV+WXjc9MHKt+i9J4QLS4u3RAoGBAMB14Ynd509QY14hw/PB\nxfS/CG5R4p0UptAaNXp7Z/KT7S9Im+/jH/PwUf3onK+3oGSo2grgGn9LtQvCt13p\nucg2KHbgUou/KEgop3mxMDVByuZpZAiRTo9MusmwR/DsBJ3/EkJXFk8wwu/fJTun\nSLkTuUZjCzEHtk05PeED9pA3\n-----END PRIVATE KEY-----\n",
    client_email:
      "firebase-adminsdk-g9pmp@aircorp-f42be.iam.gserviceaccount.com",
    client_id: "112007333328477313566",
    auth_uri: "https://accounts.google.com/o/oauth2/auth",
    token_uri: "https://oauth2.googleapis.com/token",
    auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
    client_x509_cert_url:
      "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-g9pmp%40aircorp-f42be.iam.gserviceaccount.com",
    universe_domain: "googleapis.com",
  }),
});
/* eslint-enable max-len */

admin
  .auth()
  .setCustomUserClaims("GQX45tl32VNtEdEUnoSoSXuq9js2", { admin: true })
  .then(() => {});

exports.createUser = functions
  .runWith({
    timeoutSeconds: 540,
    memory: "2GB",
  })
  .https.onCall(async (data, context) => {
    console.log(context.auth);
    if (!(context.auth && context.auth.token && context.auth.token.admin)) {
      return { response: "failed", value: "permission denied" };
    }
    try {
      const user = await admin.auth().createUser({
        disabled: false,
        displayName: data.name,
        email: data.email,
        password: data.password,
      });

      return { response: "success", value: user.uid };
    } catch (error) {
      return { response: "failed", value: error.message };
    }
  });

exports.updateUser = functions
  .runWith({
    timeoutSeconds: 540,
    memory: "2GB",
  })
  .https.onCall(async (data, context) => {
    if (!(context.auth && context.auth.token && context.auth.token.admin)) {
      return { response: "failed", value: "permission denied" };
    }
    try {
      const user = await admin.auth().updateUser(data.uid, {
        disabled: false,
        displayName: data.name,
        email: data.email,
        password: data.password,
      });

      return { response: "success", value: user.uid };
    } catch (error) {
      return { response: "failed", value: error.message };
    }
  });

exports.deleteUser = functions
  .runWith({
    timeoutSeconds: 540,
    memory: "2GB",
  })
  .https.onCall(async (data, context) => {
    if (!(context.auth && context.auth.token && context.auth.token.admin)) {
      return { response: "failed", value: "permission denied" };
    }
    return admin.auth().deleteUser(data.uid);
  });

exports.sendNotification = functions.https.onCall(async (data, context) => {
  // Extract the device token from the data object passed from the client
  const deviceToken = data.deviceToken;
  const title = data.title || "Default Title";
  const body = data.body || "Default Body Message";

  // Create the message payload
  const message = {
    notification: {
      title: title,
      body: body,
    },
    token: deviceToken,
  };

  try {
    // Send the notification
    const response = await admin.messaging().send(message);
    console.log("Successfully sent message:", response);
    return { success: true, message: "Notification sent successfully" };
  } catch (error) {
    console.error("Error sending message:", error);
    return { success: false, message: "Error sending notification", error };
  }
});
