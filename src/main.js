import "./tailwind.css";
import { invoke } from "@tauri-apps/api/core";
import Main from "./elm/Main.elm";

const app = Main.init({
  node: document.querySelector("main"),
});

if (app.ports?.sendToTauri) {
  app.ports.sendToTauri.subscribe(async (message) => {
    switch (message.tag) {
      case "GREET":
        try {
          const responseFromRust = await invoke("greet", {
            name: message.payload,
          });
          app.ports.listenForGreeting.send(responseFromRust);
        } catch (error) {
          console.error("Tauri error:", error);
          app.ports.listenForGreeting.send(`Error: ${error.message}`);
        }
        return;
    }
  });
}
