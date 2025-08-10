import React, { useState } from "react";
import { useTranslation } from "react-i18next";
import AdminDashboard from "./components/AdminDashboard";
import PromptBuilder from "./components/PromptBuilder";

export default function App() {
  const { t, i18n } = useTranslation();
  const [isAdmin, setIsAdmin] = useState(false);

  return (
    <div>
      <header>
        <h1>{t("welcome")}</h1>
        <select onChange={e => i18n.changeLanguage(e.target.value)} defaultValue="en">
          <option value="en">English</option>
          <option value="fr">Français</option>
          <option value="de">Deutsch</option>
        </select>
        <button onClick={() => setIsAdmin(!isAdmin)}>
          {isAdmin ? "User View" : "Admin View"}
        </button>
      </header>
      <main>{isAdmin ? <AdminDashboard /> : <PromptBuilder />}</main>
    </div>
  );
}
