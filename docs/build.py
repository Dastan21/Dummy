# Script from https://github.com/KristalTeam/kristal-lua-docs/blob/main/gen.py

import os
import re
import shutil

SRC_PATH = os.path.join("..", "engine")

ignore = [
  os.path.join("conf.lua"),
  os.path.join("scene", "encounter.lua"),
  os.path.join("scene", "error.lua"),
  os.path.join("scene", "game_over.lua"),
  os.path.join("scene", "main_menu.lua"),
  os.path.join("mod", "mod_list.lua"),
]

copy = []

scripts = []
copy_scripts = []

# Loop through the files recursively inside the "Dummy/engine" directory, excluding the "lib" directory
for root, dirs, files in os.walk(SRC_PATH, topdown=False):
  for name in files:
    # Get the path of the file relative to the "Dummy/engine" directory
    path = os.path.join(root, name)[len(SRC_PATH) + 1:]
    # If the file is a .lua file, and it's not in the "lib" directory, add it to the scripts list
    if path.endswith(".lua") and not path.startswith("lib" + os.path.sep):
      if path in copy:
        copy_scripts.append(path)
      elif not path in ignore:
        scripts.append(path)

# If we have a "library" folder, delete it and all of its contents
shutil.rmtree("library")

# Create a new "library" folder
os.mkdir("library")

event_calls = []

# Now we read each script file and process it
for script in scripts:
  functions = []
  classes = []
  aliases = []

  # Read the script file
  with open(os.path.join(SRC_PATH, script), encoding="utf8") as f:
    data = f.read()

    print(f"Processing {script}...")

    # Find all functions in the script file, and add them to the functions list
    for match in re.finditer(r"((?:^---.*$\n)+)?^function (\S+\(.*\))", data, flags=re.M):
      functions.append((match.group(1), match.group(2)))

    # Find the first class definition in the script file, and add it to the classes list
    for match in re.finditer(r"((?:^---.*$\n)+)?^local ([^\s,]+)(?:, super)? = ", data, flags=re.M):
      classes.append((match.group(1), match.group(2)))
      break

    # Find standalone documentation comments (usually aliases)
    for match in re.finditer(r"((?:^---.*$[\r\n]*)+)$(?!\n\S)", data, flags=re.M):
      aliases.append(match.group(1))
  
  # Create a new file in the "library" folder matching the script file name, creating the directory if it doesn't exist
  os.makedirs(os.path.join("library", os.path.dirname(script)), exist_ok=True)
  with open(os.path.join("library", script), "w", encoding="utf8") as f:
    # Write the script file name as a comment
    normal_path = script.replace("\\", "/")
    f.write(
f"""--[[
  Generated from {os.path.join(SRC_PATH, script)}

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/{normal_path}
]]""")

    f.write("\n\n---@meta\n\n")

    # Write the classes
    for class_ in classes:
      if class_[0] != None:
        # Write the documentation comments, if any exist
        f.write(class_[0])
      # Write the class definition
      f.write(f"{class_[1]} = {{}}\n\n")

    # Write the aliases
    for alias in aliases:
      if alias.startswith("---@diagnostic"):
        continue
      f.write(alias)
      f.write("\n\n")

    # Write the functions
    for function in functions:
      # Ignore love callbacks
      if "love." in function[1]:
        continue
      if function[0] != None:
        # Ignore private functions
        if "---@private" in function[0]: 
          continue
        # Write the documentation comments, if any exist
        f.write(function[0])
      # Write the function definition
      f.write(f"function {function[1]} end\n\n")

# Also process each file that should be directly copied
for script in copy_scripts:
  print(f"Copying {script}...")

  # Read the contents of the script
  f = open(os.path.join(SRC_PATH, script), "r", encoding="utf8")
  script_text = f.read()
  f.close()

  # Create a new file in the "library" folder matching the script file name, creating the directory if it doesn't exist
  os.makedirs(os.path.join("library", os.path.dirname(script)), exist_ok=True)
  with open(os.path.join("library", script), "w", encoding="utf8") as f:
    # Write the script file name as a comment
    normal_path = script.replace("\\", "/")
    f.write(
f"""--[[
  Generated from {os.path.join(SRC_PATH, script)}

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/{normal_path}
]]""")
    
    # Append the meta annotation to the file
    f.write("\n\n---@meta\n\n")

    # Copy the script to the output file
    f.write(script_text)
