#!/bin/bash

# Update Normal 1 items to use Copper 2
find src/resources/items/blueprints -name "normal_*_1.tres" -exec sed -i '' 's|Copper/Copper_[A-Za-z]*[0-9]*.png|Copper/Copper_&2.png|g' {} \;

# Update Normal 2 items to use Copper 7
find src/resources/items/blueprints -name "normal_*_2.tres" -exec sed -i '' 's|Copper/Copper_[A-Za-z]*[0-9]*.png|Copper/Copper_&7.png|g' {} \;

# Update Magic 1 items to use Cobalt 5
find src/resources/items/blueprints -name "magic_*_1.tres" -exec sed -i '' 's|Cobalt/Cobalt_[A-Za-z]*[0-9]*.png|Cobalt/Cobalt_&5.png|g' {} \;

# Update Magic 2 items to use Cobalt 9
find src/resources/items/blueprints -name "magic_*_2.tres" -exec sed -i '' 's|Cobalt/Cobalt_[A-Za-z]*[0-9]*.png|Cobalt/Cobalt_&9.png|g' {} \;
