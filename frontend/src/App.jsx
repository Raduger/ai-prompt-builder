import React from "react";
import { Helmet } from "react-helmet-async";
import PromptList from "./PromptList";

export default function App() {
  return (
    <>
      <Helmet>
        <title>AI Prompt Builder - Popular AI Prompts for Creativity</title>
        <meta
          name="description"
          content="Explore and copy 20+ popular AI prompts for writing, marketing, content creation, and more."
        />
        <meta property="og:title" content="AI Prompt Builder" />
        <meta
          property="og:description"
          content="Explore and copy 20+ popular AI prompts for writing, marketing, content creation, and more."
        />
        <meta property="og:type" content="website" />
        <meta property="og:url" content="https://aiprompts.totallifeessentials.com" />
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:title" content="AI Prompt Builder" />
        <meta
          name="twitter:description"
          content="Explore and copy popular AI prompts for writing, marketing, and more."
        />
      </Helmet>

      <PromptList />
    </>
  );
}
