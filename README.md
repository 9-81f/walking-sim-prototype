# A Space To Unwind: 3D Interaction Tech Demo
> This tech demo is a proof-of-concept for a modular, component-based 3D interaction system built in Godot 4.7.
> Set inside a single-floor studio housing (combining living, dining, kitchen, bedroom, and bathroom spaces), players can seamlessly interact with the environment, manage inventory, pickup items like foods, and inspect physical props.

[![Godot Version](https://img.shields.io/badge/Godot-v4.7--stable-blue?logo=godotengine)](https://godotengine.org/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Play Demo](https://img.shields.io/badge/itch.io-Play_in_browser-red?logo=itchdotio)](https://neg981f.itch.io/a-space-to-unwind)

---

## Overview
This project was built over a 2-month period to explore efficient 3D asset-flipping workflows while putting **composition-over-inheritance** design patterns into practice. 

The core objective was building a modular library of reusable components (`Interactor3D`, `Interactable3D`, `SwitchToggleComponent`, `AudioToggleComponent`, `TweenMeshComponent`, `VideoToggleComponent`) that attach behavior directly to 3D props without creating rigid class hierarchies.

### Lessons Learned
* **Decoupled Architecture:** Composition keeps scene nodes lightweight and easily extendable.
* **Event Handling:** Decoupled signal bus autoload (`UIEvents`) for UI updates and interaction alerts.
* **Targeted Inheritance:** Inheritance was kept minimal, reserved exclusively for polymorphic templates (e.g., FSM State nodes).
* **Scalable Prototyping:** These modular components serve as the foundation for rapid prototyping in future 3D projects.

## Project Structure
I chose to lean in to single main scene structure as it's the one I'm most comfortable in.
Here is the overview of the project structure:
```
res://
├── assets/          # 3D models, textures, and audio
├── core/            # Autoloads (Inventory data, signal bus), custom resource blueprints, custom parent class, core components, main scene, & core Uis
└── game/            # Actors, game wide components, interactables, items, levels, game wide custom resources, game wide Uis (e.g: Inspect & Inventory UI)
```

## How to Run
1. Clone this repository:
   ```bash
   git clone [https://github.com/9-81f/walking-sim-prototype.git](https://github.com/9-81f/walking-sim-prototype.git)
2. Open Godot Engine 4.7 (or compatible 4.x version).
3. Import the project by selecting project.godot.
4. Run the main scene (F5).

## Controls:
> Currently only support keyboard + mouse for gameplay control

* WASD: Move
* Shift: Run
* C: Crouch
* Space: Jump
* F: Interact
* I: Toggle Inventory
* Tab: Toggle Controls
