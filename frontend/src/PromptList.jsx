import React, { useState } from "react";

const prompts = [
  { id: 1, title: "Email Writing", prompt: "Write a professional email to request a meeting with a potential client." },
  { id: 2, title: "Blog Post Ideas", prompt: "Generate 5 creative blog post ideas for a fitness website." },
  { id: 3, title: "Product Description", prompt: "Write a compelling product description for a new eco-friendly water bottle." },
  { id: 4, title: "Social Media Post", prompt: "Create a catchy Instagram caption for a coffee shop promoting a new seasonal drink." },
  { id: 5, title: "Customer Support Reply", prompt: "Write a polite response to a customer complaining about a delayed order." },
  { id: 6, title: "Sales Email", prompt: "Draft a persuasive sales email introducing a new SaaS product to small businesses." },
  { id: 7, title: "Job Description", prompt: "Create a detailed job description for a remote frontend developer position." },
  { id: 8, title: "Meeting Agenda", prompt: "Outline a meeting agenda for a product launch planning session." },
  { id: 9, title: "Technical Explanation", prompt: "Explain blockchain technology in simple terms for a non-technical audience." },
  { id: 10, title: "Creative Story Starter", prompt: "Write the first paragraph of a mystery novel set in Victorian London." },
  { id: 11, title: "Interview Questions", prompt: "List 10 behavioral interview questions for a project manager role." },
  { id: 12, title: "SEO Keywords", prompt: "Generate SEO keywords for an online store selling handmade jewelry." },
  { id: 13, title: "Newsletter Intro", prompt: "Write a friendly introduction paragraph for a monthly tech newsletter." },
  { id: 14, title: "Event Invitation", prompt: "Create an invitation message for a corporate networking event." },
  { id: 15, title: "FAQ Answer", prompt: "Provide an answer explaining the refund policy for an e-commerce website." },
  { id: 16, title: "Press Release", prompt: "Draft a press release announcing a startup’s Series A funding round." },
  { id: 17, title: "App Store Description", prompt: "Write an engaging description for a new meditation app." },
  { id: 18, title: "Video Script", prompt: "Create a script outline for a 2-minute explainer video about renewable energy." },
  { id: 19, title: "Translation", prompt: "Translate the phrase 'Welcome to our website' into French, Spanish, and German." },
  { id: 20, title: "Summary", prompt: "Summarize the key points of a research article on climate change." }
];

export default function PromptList() {
  const [copiedId, setCopiedId] = useState(null);

  const copyToClipboard = (text, id) => {
    navigator.clipboard.writeText(text).then(() => {
      setCopiedId(id);
      setTimeout(() => setCopiedId(null), 2000);
    });
  };

  return (
    <div style={{ maxWidth: 800, margin: "2rem auto", fontFamily: "Arial, sans-serif" }}>
      <h2>Popular AI Prompts</h2>
      <input
        type="text"
        placeholder="Search prompts..."
        style={{ width: "100%", padding: "0.5rem", marginBottom: "1rem", fontSize: "1rem" }}
        onChange={(e) => {
          const filter = e.target.value.toLowerCase();
          const items = document.querySelectorAll(".prompt-item");
          items.forEach(item => {
            const text = item.innerText.toLowerCase();
            item.style.display = text.includes(filter) ? "block" : "none";
          });
        }}
      />
      {prompts.map(({ id, title, prompt }) => (
        <div
          key={id}
          className="prompt-item"
          style={{
            border: "1px solid #ddd",
            borderRadius: 6,
            padding: "1rem",
            marginBottom: "1rem",
            position: "relative",
            background: "#f9f9f9"
          }}
        >
          <h3 style={{ margin: "0 0 0.5rem" }}>{title}</h3>
          <pre
            style={{
              whiteSpace: "pre-wrap",
              wordWrap: "break-word",
              marginBottom: "0.5rem",
              fontFamily: "'Courier New', Courier, monospace",
              fontSize: "0.9rem"
            }}
          >
            {prompt}
          </pre>
          <button
            onClick={() => copyToClipboard(prompt, id)}
            style={{
              position: "absolute",
              top: 12,
              right: 12,
              padding: "0.25rem 0.5rem",
              fontSize: "0.8rem",
              cursor: "pointer",
              borderRadius: 4,
              border: "1px solid #aaa",
              background: copiedId === id ? "#4caf50" : "#fff",
              color: copiedId === id ? "#fff" : "#000"
            }}
          >
            {copiedId === id ? "Copied!" : "Copy"}
          </button>
        </div>
      ))}
    </div>
  );
}
