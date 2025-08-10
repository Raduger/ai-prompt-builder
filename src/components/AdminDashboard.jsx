import React, { useEffect, useState } from "react";

export default function AdminDashboard() {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    fetch("/api/admin/users", { headers: { Authorization: "admin-token" } })
      .then(res => res.json())
      .then(setUsers)
      .catch(console.error);
  }, []);

  return (
    <div>
      <h2>Admin Dashboard</h2>
      <ul>
        {users.map(u => (
          <li key={u.id}>{u.email} - {u.subscription_status}</li>
        ))}
      </ul>
    </div>
  );
}
