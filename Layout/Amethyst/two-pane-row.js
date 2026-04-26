function layout() {
    return {
        name: "Two Pane Row",
        initialState: {
            mainPaneCount: 1
        },
        getFrameAssignments: (windows, screenFrame) => {
            if (windows.length === 0) return {};
            
            let frames = {};

            // If there's only one window, it takes up the entire screen
            if (windows.length === 1) {
                frames[windows[0].id] = {
                    x: screenFrame.x,
                    y: screenFrame.y,
                    width: screenFrame.width,
                    height: screenFrame.height
                };
                return frames;
            }

            // Split horizontally into two parts
            const upperHeight = screenFrame.height / 2;
            const lowerHeight = screenFrame.height / 2;

            // Main window in the upper half
            frames[windows[0].id] = {
                x: screenFrame.x,
                y: screenFrame.y,
                width: screenFrame.width,
                height: upperHeight
            };

            // Remaining windows in the lower half, each with equal width
            const remainingWindows = windows.slice(1);
            remainingWindows.forEach((window, index) => {
                frames[window.id] = {
                    x: screenFrame.x,
                    y: screenFrame.y + upperHeight,
                    width: screenFrame.width,
                    height: lowerHeight
                };
            });

            return frames;
        }
    };
}
