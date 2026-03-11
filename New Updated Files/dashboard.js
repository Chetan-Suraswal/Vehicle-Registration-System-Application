// ==============================
// FIREBASE IMPORTS (ONCE ONLY)
// ==============================
import { getAuth, onAuthStateChanged } from
  "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

import {
  getFirestore,
  collection,
  addDoc,
  getDocs,
  query,
  where,
  doc,
  getDoc,
  setDoc,
  serverTimestamp
} from
  "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";

// ==============================
// INIT
// ==============================
const auth = getAuth();
const db = getFirestore();

// ==============================
// AUTH GUARD
// ==============================
onAuthStateChanged(auth, (user) => {
  if (!user) {
    window.location.href = "login.html";
  } else {
    console.log("Logged in:", user.uid);
    loadPage("profile");
  }
});

// ==============================
// DASHBOARD CORE
// ==============================
document.addEventListener("DOMContentLoaded", () => {

  const mainContent = document.getElementById("mainContent");
  const sidebar = document.getElementById("sidebar");
  const toggleBtn = document.getElementById("toggleSidebar");

  toggleBtn.onclick = () => sidebar.classList.toggle("collapsed");

  // PAGE LOADER
  async function loadPage(page) {
    try {
      const res = await fetch(`${page}.html`);
      if (!res.ok) throw new Error("Page not found");

      mainContent.innerHTML = await res.text();

      if (page === "profile") initProfilePage();
      if (page === "add_vehicle") initAddVehiclePage();
      if (page === "my-vehicles") loadMyVehicles();

    } catch (err) {
      mainContent.innerHTML = `<h2>Page "${page}" not found</h2>`;
      console.error(err);
    }
  }

  // SIDEBAR
  document.querySelectorAll(".sidebar a[data-page]").forEach(link => {
    link.onclick = e => {
      e.preventDefault();
      loadPage(link.dataset.page);
    };
  });

  // DEFAULT
  loadPage("overview");

  document.getElementById("logoutBtn").onclick = () => {
    window.location.href = "login.html";
  };

  window.loadPage = loadPage;
});

// ==============================
// PROFILE PAGE
// ==============================
window.initProfilePage = function () {
  const saveBtn = document.getElementById("saveProfileBtn");
  if (!saveBtn) return;

  onAuthStateChanged(auth, async user => {
    if (!user) return;

    const snap = await getDoc(doc(db, "users", user.uid));
    if (!snap.exists()) return;

    const d = snap.data();
    displayId.value = d.userId || "";
    email.value = d.email || "";
    fullName.value = d.fullName || "";
    mobile.value = d.mobile || "";
    address.value = d.address || "";
    city.value = d.city || "";
    state.value = d.state || "";
    pincode.value = d.pincode || "";
  });

  saveBtn.onclick = async () => {
    const user = auth.currentUser;
    if (!user) return alert("Not logged in");

    await setDoc(doc(db, "users", user.uid), {
      userId: displayId.value,
      email: user.email,
      fullName: fullName.value,
      mobile: mobile.value,
      address: address.value,
      city: city.value,
      state: state.value,
      pincode: pincode.value,
      updatedAt: serverTimestamp()
    }, { merge: true });

    alert("Profile saved");
  };
};

// ==============================
// ADD VEHICLE PAGE
// ==============================
window.initAddVehiclePage = function () {

  const form = document.getElementById("vehicleForm");
  if (!form) return;

  form.onsubmit = async (e) => {
    e.preventDefault();

    const user = auth.currentUser;
    if (!user) return alert("Not logged in");

    const vehicleData = {
      userId: user.uid, // 🔥 REQUIRED
      ownerName: ownerName.value,
      ownerMobile: ownerMobile.value,
      ownerEmail: ownerEmail.value,
      ownerAddress: ownerAddress.value,
      vehicleType: vehicleType.value,
      vehicleBrand: vehicleBrand.value,
      vehicleModel: vehicleModel.value,
      engineNumber: engineNumber.value,
      chassisNumber: chassisNumber.value,
      insuranceCompany: insuranceCompany.value,
      policyNumber: policyNumber.value,
      aadhaarNumber: aadhaarNumber.value,
      invoiceNumber: invoiceNumber.value,
      createdAt: serverTimestamp()
    };

    try {
      await addDoc(collection(db, "vehicles"), vehicleData);
      form.reset();
      alert("Vehicle registered");
      loadPage("my-vehicles");
    } catch (err) {
      console.error(err);
      alert("Failed to save vehicle");
    }
  };
};

// ==============================
// MY VEHICLES PAGE
// ==============================
window.loadMyVehicles = async function () {

  const table = document.getElementById("vehicleTableBody");
  if (!table) return;

  const user = auth.currentUser;
  if (!user) return;

  const q = query(
    collection(db, "vehicles"),
    where("userId", "==", user.uid)
  );

  const snap = await getDocs(q);
  table.innerHTML = "";

  if (snap.empty) {
    table.innerHTML = `<tr><td colspan="6">No vehicles found</td></tr>`;
    return;
  }

  snap.forEach(docSnap => {
    const v = docSnap.data();
    const date =
      v.createdAt?.toDate
        ? v.createdAt.toDate().toLocaleDateString()
        : "-";

    const row = document.createElement("tr");
    row.innerHTML = `
      <td>${v.engineNumber || "-"}</td>
      <td>${v.ownerName || "-"}</td>
      <td>${v.vehicleType || "-"}</td>
      <td>${date}</td>
      <td>Vehicle Added</td>
    `;
    table.appendChild(row);
  });
};
