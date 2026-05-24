const resumeToggles = document.querySelectorAll(".resume-toggle");

for (const toggle of resumeToggles) {
  toggle.addEventListener("click", () => {
    const panelId = toggle.getAttribute("aria-controls");
    if (!panelId) return;

    const panel = document.getElementById(panelId);
    if (!panel) return;

    const isOpen = toggle.getAttribute("aria-expanded") === "true";
    toggle.setAttribute("aria-expanded", String(!isOpen));
    panel.hidden = isOpen;
  });
}

const toolsToggles = document.querySelectorAll(".tools-toggle");

for (const toggle of toolsToggles) {
  toggle.addEventListener("click", () => {
    const panelId = toggle.getAttribute("aria-controls");
    if (!panelId) return;

    const panel = document.getElementById(panelId);
    if (!panel) return;

    const isOpen = toggle.getAttribute("aria-expanded") === "true";
    toggle.setAttribute("aria-expanded", String(!isOpen));
    panel.hidden = isOpen;
  });
}
