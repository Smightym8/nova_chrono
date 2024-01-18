#!/bin/bash

# Basisverzeichnis für die Library (angenommen, das Skript befindet sich im Verzeichnis 'nova_chrono/macos/scripts')
LIB_DIR="./../../encryptionLib/"

# Verzeichnis für den Build
BUILD_DIR="${LIB_DIR}/cmake-build-release"

# Erstellen Sie das Build-Verzeichnis, wenn es nicht existiert
mkdir -p "${BUILD_DIR}"

# Wechseln in das Build-Verzeichnis
cd "${BUILD_DIR}"

# Führen Sie CMake aus, um die Build-Systemdateien zu konfigurieren
cmake -DCMAKE_BUILD_TYPE=Release "${LIB_DIR}"

# Kompilieren Sie die Bibliothek
cmake --build .

# Überprüfen, ob die Kompilierung erfolgreich war
if [ $? -ne 0 ]; then
    echo "Fehler beim Kompilieren der C-Bibliothek"
    exit 1
fi

# Der Name der kompilierten Bibliothek (angepasst an den tatsächlichen Namen)
LIB_NAME="libencryptionLib.dylib"

# Ort, an dem die Bibliothek kopiert werden soll (angepasst an Ihre Struktur)
# Nehmen wir an, Sie möchten sie im 'macos' Ordner des Flutter-Projekts ablegen
DEST_DIR="../../macos/Flutter/ephemeral"

# Kopieren Sie die kompilierte Bibliothek ins richtige Verzeichnis der Flutter-Anwendung
cp "${BUILD_DIR}/${LIB_NAME}" "${DEST_DIR}"

echo "C-Bibliothek erfolgreich kompiliert und kopiert"