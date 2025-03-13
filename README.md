# Solitaire
Welcome to the Solitaire game,
developed using the Love2D game engine,
renowned for its lightweight and high-performance capabilities.

![Game Screenshot](/../screenshots/game-screenshot.png?raw=true "Game Screenshot")
## How to Run the Game
For detailed guidance on setting up and running games with Love2D,
please refer to the [Love2D Getting Started Guide](https://love2d.org/wiki/Getting_Started).
## Development Roadmap
### Upcoming Features and Enhancements
- **Animations**
 - [ ] Implement animations for the initial setup of the board.
 - [ ] Implement bounceing foundations animation at the game beat.
- **Features**
 - [ ] Enable windowed mode functionality for PC platforms.
- **Code Refactoring**
 - [ ] Consider creating a dedicated directory for external libraries, if required.
 - [ ] Refactor `cards/piles.lua` for consistency with `cards/card.lua`,
 ensuring that piles have their own methods. For example,
 enhance the functionality to transfer cards from a pile to a hold state.
