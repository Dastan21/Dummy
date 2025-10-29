# Script from https://github.com/KristalTeam/kristal-lua-docs/blob/main/gen.py

import os
import re
import shutil

SRC_PATH = os.path.join("..", "engine")

ignore = [
  os.path.join("main.lua"),
  os.path.join("conf.lua"),
  os.path.join("scene", "encounter.lua"),
  os.path.join("scene", "error.lua"),
  os.path.join("scene", "game_over.lua"),
  os.path.join("scene", "main_menu.lua"),
]

copy = [
  os.path.join("constants.lua")
]

scripts = []
copy_scripts = []

for root, dirs, files in os.walk(SRC_PATH, topdown=False):
  for name in files:
    path = os.path.join(root, name)[len(SRC_PATH) + 1:]
    if path.endswith(".lua") and not path.startswith("mods" + os.path.sep) and not path.startswith("lib" + os.path.sep):
      if path in copy:
        copy_scripts.append(path)
      elif not path in ignore:
        scripts.append(path)

shutil.rmtree("library")
os.mkdir("library")

for script in scripts:
  functions = []
  classes = []
  aliases = []

  with open(os.path.join(SRC_PATH, script), encoding="utf8") as f:
    data = f.read()

    print(f"Processing {script}...")

    for match in re.finditer(r"((?:^---.*$\n)+)?^function (\S+\(.*\))", data, flags=re.M):
      functions.append((match.group(1), match.group(2)))

    for match in re.finditer(r"((?:^---.*$\n)+)?^local ([^\s,]+)(?:, super)? = ", data, flags=re.M):
      classes.append((match.group(1), match.group(2)))
      break

    for match in re.finditer(r"((?:^---.*$[\r\n]*)+)$(?!\n\S)", data, flags=re.M):
      aliases.append(match.group(1))
  
  os.makedirs(os.path.join("library", os.path.dirname(script)), exist_ok=True)
  with open(os.path.join("library", script), "w", encoding="utf8") as f:
    normal_path = script.replace("\\", "/")
    f.write(
f"""--[[
  Generated from {os.path.join(SRC_PATH, script)}

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/{normal_path}
]]""")
    f.write("\n\n---@meta\n\n")

    for class_ in classes:
      if class_[0] != None:
        f.write(class_[0])
      f.write(f"{class_[1]} = {{}}\n\n")

    for alias in aliases:
      if alias.startswith("---@diagnostic"):
        continue
      f.write(alias)
      f.write("\n\n")

    for function in functions:
      if "love." in function[1]:
        continue
      if function[0] != None:
        if "---@private" in function[0]: 
          continue
        f.write(function[0])
      f.write(f"function {function[1]} end\n\n")

for script in copy_scripts:
  print(f"Copying {script}...")

  f = open(os.path.join(SRC_PATH, script), "r", encoding="utf8")
  script_text = f.read()
  f.close()

  os.makedirs(os.path.join("library", os.path.dirname(script)), exist_ok=True)
  with open(os.path.join("library", script), "w", encoding="utf8") as f:
    normal_path = script.replace("\\", "/")
    f.write(
f"""--[[
  Generated from {os.path.join(SRC_PATH, script)}

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/{normal_path}
]]""")
    f.write("\n\n---@meta\n\n")
    f.write(script_text)
