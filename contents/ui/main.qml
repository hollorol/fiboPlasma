import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

WallpaperItem {
    id: root

    // Configuration properties
    property color backgroundColor: wallpaper.configuration.BackgroundColor || "#000000"
    property color baseColor: wallpaper.configuration.BaseColor || "#808080"
    property color minuteColor: wallpaper.configuration.MinuteColor || "#ff0000"
    property color hourColor: wallpaper.configuration.HourColor || "#0000ff"
    property color bothColor: wallpaper.configuration.BothColor || "#00ff00"
    property int gapSize: wallpaper.configuration.GapSize || 3
    property real boxHeightRate: wallpaper.configuration.BoxHeightRate || 0.9
    
    // Fibonacci numbers for the clock blocks
    readonly property var fibBlocks: [5, 3, 2, 1, 1]
    
    // Track screen count for dynamic monitor changes
    property int screenCount: Qt.application.screens.length
    
    Connections {
        target: Qt.application
        function onScreensChanged() {
            screenCount = Qt.application.screens.length;
        }
    }
    
    // Timer to update every minute (or every 5 minutes to match your C code)
    Timer {
        interval: 5000 // Update every 5 seconds to catch 5-minute changes
        running: true
        repeat: true
        onTriggered: {
            // Request repaint on all canvas instances
            for (var i = 0; i < repeater.count; i++) {
                var item = repeater.itemAt(i);
                if (item && item.children[0]) {
                    item.children[0].requestPaint();
                }
            }
        }
    }
    
    function getFibTime() {
        var now = new Date();
        var minute = now.getMinutes();
        minute = Math.floor(minute / 5) * 5; // Round to nearest 5 minutes
        var hour = now.getHours() % 12;
        if (hour === 0) hour = 12;
        
        var mins = [0, 0, 0, 0, 0];
        var hours = [0, 0, 0, 0, 0];
        var blockElement = 0;
        
        // Calculate minutes representation
        while (minute > 0 && blockElement < 5) {
            if (fibBlocks[blockElement] * 5 > minute) {
                blockElement++;
                continue;
            }
            mins[blockElement] = 1;
            minute -= fibBlocks[blockElement] * 5;
            blockElement++;
        }
        
        // Calculate hours representation
        blockElement = 0;
        while (hour > 0 && blockElement < 5) {
            if (fibBlocks[blockElement] > hour) {
                blockElement++;
                continue;
            }
            hours[blockElement] = 1;
            hour -= fibBlocks[blockElement];
            blockElement++;
        }
        
        // Combine results (0=base, 1=min, 2=hour, 3=both)
        var result = [];
        for (var i = 0; i < 5; i++) {
            result[i] = mins[i] + 2 * hours[i];
        }
        
        // Handle ambiguity of the two '1' blocks
        if (result[3] === 3 && result[4] === 0) {
            result[3] = 2; // First '1' block to hour
            result[4] = 1; // Second '1' block to minute
        }
        
        return result;
    }
    
    function getBlockColor(colorIndex) {
        switch(colorIndex) {
            case 0: return baseColor;     // base/off
            case 1: return minuteColor;   // minute only
            case 2: return hourColor;     // hour only
            case 3: return bothColor;     // both
            default: return baseColor;
        }
    }

    Rectangle {
        anchors.fill: parent
        color: backgroundColor

        // Draw a clock on each screen in multi-monitor setups
        Repeater {
            id: repeater
            model: screenCount
            
            Item {
                // Position this item to cover the specific screen
                x: Qt.application.screens[index] ? Qt.application.screens[index].virtualX : 0
                y: Qt.application.screens[index] ? Qt.application.screens[index].virtualY : 0
                width: Qt.application.screens[index] ? Qt.application.screens[index].width : parent.width
                height: Qt.application.screens[index] ? Qt.application.screens[index].height : parent.height
                
                Canvas {
                    id: canvas
                    anchors.fill: parent

                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.clearRect(0, 0, width, height);
                        
                        // Calculate layout dimensions for this screen
                        var availableHeight = height * boxHeightRate;
                        var unit = Math.floor(availableHeight / 5);
                        if (unit <= 0) return;
                        
                        // Total layout size: 8 units wide, 5 units high
                        var totalWidth = 8 * unit;
                        var totalHeight = 5 * unit;
                        
                        // Center the clock on this screen
                        var startX = (width - totalWidth) / 2;
                        var startY = (height - totalHeight) / 2;
                        
                        // Get current time representation
                        var blockColors = getFibTime();
                        
                        // Define the 5 rectangles in Fibonacci layout
                        var rects = [];
                        
                        // Block 2: Top-left box (size 2)
                        rects[2] = {
                            x: startX,
                            y: startY,
                            w: 2 * unit - gapSize,
                            h: 2 * unit - gapSize,
                            color: blockColors[2]
                        };
                        
                        // Block 1: Bottom-left box (size 3)
                        rects[1] = {
                            x: startX,
                            y: startY + 2 * unit,
                            w: 3 * unit - gapSize,
                            h: 3 * unit - gapSize,
                            color: blockColors[1]
                        };
                        
                        // Block 3: Top small box (size 1)
                        rects[3] = {
                            x: startX + 2 * unit,
                            y: startY,
                            w: 1 * unit - gapSize,
                            h: 1 * unit - gapSize,
                            color: blockColors[3]
                        };
                        
                        // Block 4: Bottom small box (size 1)
                        rects[4] = {
                            x: startX + 2 * unit,
                            y: startY + 1 * unit,
                            w: 1 * unit - gapSize,
                            h: 1 * unit - gapSize,
                            color: blockColors[4]
                        };
                        
                        // Block 0: Large box (size 5)
                        rects[0] = {
                            x: startX + 3 * unit,
                            y: startY,
                            w: 5 * unit - gapSize,
                            h: 5 * unit - gapSize,
                            color: blockColors[0]
                        };
                        
                        // Draw all rectangles
                        for (var i = 0; i < 5; i++) {
                            var rect = rects[i];
                            var color = getBlockColor(rect.color);
                            
                            ctx.fillStyle = color;
                            ctx.fillRect(rect.x, rect.y, rect.w, rect.h);
                        }
                    }
                    
                    Component.onCompleted: requestPaint()
                }
            }
        }
    }
}
