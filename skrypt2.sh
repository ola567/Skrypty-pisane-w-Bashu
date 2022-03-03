#!/bin/bash

show () {
	clear
	echo
	echo "1.Nazwa pliku: $PLIK "
	echo "2.Katalog: $KATALOG"
	echo "3.Utworzony w ciągu ostatnich n dni: $DNI"
	echo "4.Rozmiar mniejszy niż: $MNIEJSZY"
	echo "5.Dostęp: $DOSTEP"
	echo "6.Zawartość pliku: $ZAWARTOSC "
	echo "7.Szukaj "
	echo "8.Koniec "
	echo
}


show
read NUMER
until [[ $NUMER -ge 8 ]]; do
	case $NUMER in
		1) 
			echo "Podaj nazwę pliku: "
			read PLIK
			SZUKAJ_PLIK="-name $PLIK"
			if [[ -z $PLIK ]]; then
				SZUKAJ_PLIK=""
			fi
			show;;
		2)
			echo "Podaj nazwę katalogu: "
			read KATALOG
			SZUKAJ_KAT=$KATALOG
			if [[ -z $KATALOG ]]; then
				SZUKAJ_KAT=""
			fi
			show;;
		3)
		       	echo "Podaj liczbę dni: "
			read DNI
			SZUKAJ_DNI="-ctime -${DNI}"
			if [[ -z $DNI ]]; then
				SZUKAJ_DNI=""
			fi
			show;;
		4) 
			echo "Podaj mniejszy rozmiar: "
			read MNIEJSZY
			SZUKAJ_MNIEJSZY="-size -${MNIEJSZY}c"
			if [[ -z $MNIEJSZY ]]; then
				SZUKAJ_MNIEJSZy=""
			fi
			show;;	
		5) 
			echo "Podaj szukany dostęp: "
			read DOSTEP
			SZUKAJ_DOSTEP="-perm $DOSTEP"
			if [[ -z $DOSTEP ]]; then
				SZUKAJ_DOSTEP=""
			fi
			show;;
		6)
		         echo "Podaj zawartość: "
			 read ZAWARTOSC
			 SZUKAJ_ZAWARTOSC="-exec grep -l -i $ZAWARTOSC {} ;"
			 if [[ -z $ZAWARTOSC ]]; then
				 SZUKAJ_ZAWARTOSC=""
			 fi
			 show;;
		7) 
			SZUKAJ=$(find ./$SZUKAJ_KAT $SZUKAJ_PLIK -type f $SZUKAJ_DNI $SZUKAJ_MNIEJSZY $SZUKAJ_DOSTEP $SZUKAJ_ZAWARTOSC)
			if [[ -z "$SZUKAJ" ]]; then
				echo "Nie ma takiego pliku"
			else 
				echo "Znaleziono plik"
				echo $SZUKAJ
			fi;;
	esac
	read NUMER
done

