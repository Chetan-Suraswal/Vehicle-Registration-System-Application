// Register User (Real Auth)

import { createUserWithEmailAndPassword } from
    "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

createUserWithEmailAndPassword(auth, email, password)
    .then(() => window.location.href = "dashboard.html")
    .catch(err => alert(err.message));





// Login User
import { signInWithEmailAndPassword } from
    "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

signInWithEmailAndPassword(auth, email, password)
    .then(() => window.location.href = "dashboard.html")
    .catch(err => alert("Invalid credentials"));




// Save Notes (Firestore)
import { doc, setDoc } from
    "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";

await setDoc(doc(db, "notes", user.uid), {
    content: notes,
    updatedAt: new Date()
});


// Load Notes (Per User)
import { getDoc, doc } from
    "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";

const snap = await getDoc(doc(db, "notes", user.uid));
if (snap.exists()) {
    textarea.value = snap.data().content;
}

