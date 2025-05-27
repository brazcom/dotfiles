#!/bin/bash
# Script per aggiornare il database di AIDE dopo aggiornamenti

echo "Inizializzo aggiornamento database AIDE..."
sudo aide --update

echo "Spostando il nuovo database nella posizione corretta..."
sudo mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

echo "Database AIDE aggiornato con successo!"
