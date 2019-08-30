/* Set up map and palette */

@ocean: #AECAD0;
#ocean[zoom>=9] { polygon-fill: @ocean; }

Map { 
	buffer-size: 0;
	background-image: url(images/background_512.jpg);
	font-directory: url(fonts);
}
@balthazar: "Balthazar Regular";
@sans: "Josefin Sans Regular";
@sans_italic: "Josefin Sans Italic";
@sans_semibold_italic: "Josefin Sans SemiBold Italic";

/* Landuse (=playground, park) */

#landuse {
	polygon-pattern-file: url(images/diagonal_5.png);
	polygon-pattern-alignment: global;
	line-color: #777;
	line-width: 1;
}

/* Roads (=footway, secondary, primary, service, residential) */

#roads[zoom>=15] { /* Casing */
	line-width: 4;
	[zoom=17] { line-width: 6; }
	[zoom=18] { line-width: 9; }
	[zoom=19] { line-width: 13; }
	[zoom>19] { line-width: 19; }
	line-color: #444;
	[type='primary'],[type='secondary'] { 
		line-width: 6;
		[zoom=17] { line-width: 9; }
		[zoom=18] { line-width: 12; }
		[zoom=19] { line-width: 18; }
		[zoom>19] { line-width: 24; }
	}
}
#roads::centreline { /* Centreline */
	line-width: 3;
	[zoom=17] { line-width: 5; }
	[zoom=18] { line-width: 8; }
	[zoom=19] { line-width: 12; }
	[zoom>19] { line-width: 18; }
	line-color: #E8E0C8;
	[type='primary'],[type='secondary'] { 
		line-width: 5;
		[zoom=17] { line-width: 8; }
		[zoom=18] { line-width: 11; }
		[zoom=19] { line-width: 17; }
		[zoom>19] { line-width: 23; }
	}
}
#road_names[zoom>=17] {
    text-name: "[name].replace(' ','   ')";
    text-face-name: @balthazar;
    text-placement: line;
    text-fill: #444;
    text-size: 18;
	text-character-spacing: 5;
	[zoom<18] { text-halo-fill: #E8E0C8; text-halo-radius: 2; }
	[zoom=18] { text-halo-fill: #E8E0C8; text-halo-radius: 1; }
	[zoom=17] { text-size: 15; text-character-spacing: 3; }
}

#minor_roads[zoom>=17] {
	line-color: #444;
	line-width: 2;
	line-dasharray: 3,3;
}

/* Buildings
   (=saw_mill,  marketplace, church, factory, gallery, school, place_of_worship, hotel, 
     residential, library, bank, yes, shop) */

#buildings {
	polygon-fill: #D0C0A8;
	[type='shop'],[type='bank'],[type='marketplace'],[type='gallery'],
	[type='hotel'],[type='bank'] { polygon-fill: #D9CB48; }
	[type='church'],[type='place_of_worship'] { polygon-fill: #7EA0A9; }
	[type='school'],[type='library'] { polygon-fill: #D67888; }
	[type='factory'],[type='saw_mill'] { polygon-fill: #B7AF9C; }
	[zoom=17] { line-width: 0.1; line-color: #000; }
	[zoom>=18] { line-width: 0.2; line-color: #000; }
}

#buildings::name[zoom>=15] {
	text-name: '[name]';
	text-face-name: @sans_italic;
	[type='shop'],[type='bank'],[type='marketplace'],[type='gallery'],[type='hotel'],[type='bank'],
	[type='church'],[type='place_of_worship'],
	[type='school'],[type='library'] { text-face-name: @sans_semibold_italic; }
	text-fill: #444;
	text-size: 14;
	text-wrap-width: 40;
	[zoom<=17] { text-size: 10; text-wrap-width: 30; }
	[zoom<=16] { text-halo-fill: #E8E0C8; text-halo-radius: 1; }
}

/* Places */

#places[zoom>=18] {
	text-name: '[name]';
    text-face-name: @sans;
	text-fill: #444;
	text-size: 18;
	text-wrap-width: 40;
	text-character-spacing: 5;
	text-line-spacing: 5;
}
