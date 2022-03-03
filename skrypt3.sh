#!/bin/bash

ODP=0
until [[ "$ODP" == 8 ]]; do

	N1="1.Nazwa pliku: $PLIK"
	N2="2.Katalog: $KATALOG"
	N3="3.Utworzony w ciągu ostatnich n dni: $DNI"
	N4="4.Rozmiar mniejszy niż: $MNIEJSZY"
	N5="5.Dostęp: $DOSTEP"
	N6="6.Zawartość pliku: $ZAWARTOSC"
	N7="7.Szukaj"
	N8="8.Koniec"

	MENU=("$N1" "$N2" "$N3" "$N4" "$N5" "$N6" "$N7" "$N8")

	ODP=$(zenity --list --title "Szukanie plików" --text "Wybierz opcję" --column=MENU "${MENU[@]}" --height 500 --width 500)
 
	case "$ODP" in
		$N1) 
			PLIK=$(zenity --entry --title "Szukanie" --text "Podaj nazwę pliku")
			SZUKAJ_PLIK="-name $PLIK"
			if [[ -z $PLIK ]]; then
				SZUKAJ_PLIK=""
			fi;;
		$N2)
			KATALOG=$(zenity --entry --title "Szukanie" --text "Podaj katalog ")
			SZUKAJ_KAT=$KATALOG
			if [[ -z $KATALOG ]]; then
				SZUKAJ_KAT=""
			fi;;
		$N3)
			DNI=$(zenity --scale --title "Szukanie" --text "Podaj ilość dni" --min-value 0 --max-value 30 --value 2)
			SZUKAJ_DNI="-ctime -${DNI}"
			if [[ -z $DNI ]]; then
				SZUKAJ_DNI=""
			fi;;
		$N4) 
			MNIEJSZY=$(zenity --entry --title "Szukanie" --text "Podaj rozmiar")
			SZUKAJ_MNIEJSZY="-size -${MNIEJSZY}c"
			if [[ -z $MNIEJSZY ]]; then
				SZUKAJ_MNIEJSZy=""
			fi;;	
		$N5) 
			DOSTEP=$(zenity --entry --title "Szukaj" --text "Podaj dostęp")
			SZUKAJ_DOSTEP="-perm $DOSTEP"
			if [[ -z $DOSTEP ]]; then
				SZUKAJ_DOSTEP=""
			fi;;
		$N6)
		         ZAWARTOSC=$(zenity --entry --title "Szukaj" --text "Podaj zawartość")
			 SZUKAJ_ZAWARTOSC="-exec grep -l -i $ZAWARTOSC {} ;"
			 if [[ -z $ZAWARTOSC ]]; then
				 SZUKAJ_ZAWARTOSC=""
			 fi;;
		$N7) 
			SZUKAJ=$(find ./$SZUKAJ_KAT $SZUKAJ_PLIK -type f $SZUKAJ_DNI $SZUKAJ_MNIEJSZY $SZUKAJ_DOSTEP $SZUKAJ_ZAWARTOSC)
			if [[ -z $SZUKAJ ]]; then
				zenity --warning --title "Uwaga!" --text "Nie znaleziono plików!" --ellipsize
			else
				zenity --info --title "Udało się" --text "Znaleziono pliki:\n${SZUKAJ}" --ellipsize
			fi;;
		$N8)
			ODP=8;
	esac
done
