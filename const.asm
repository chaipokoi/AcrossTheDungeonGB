        IF      !DEF(CONST_ASM)
CONST_ASM  SET  1

INCLUDE "include/Hardware.inc"

;Définition des variables de direction
_DIR_LEFT EQU 0
_DIR_UP EQU 1
_DIR_RIGHT EQU 2
_DIR_DOWN EQU 3

;Définition des variables relatives au pad
_PAD_LEFT EQU $CD
_PAD_RIGHT EQU $CE
_PAD_UP EQU $CB
_PAD_DOWN EQU $C7


;Sprite Ram, point de départ pour le stockage des sprites
_SRAM EQU _VRAM+$0800
_SINVX EQU $20 ;code permettant d'inverser un sprite sur l'axe des x
_SNORM EQU 0

;BG Map DATA 1
_BG1RAM EQU _VRAM+$1800
;BG MAP DATA 2
_BG2RAM EQU _VRAM+$1C00

;Variable temporaire permettant de réaliser des calculs dans les fonctions nécessitant plus de trois registres
; A noter que _TEMP+1 est aussi réservé (pour les calculs d'adresse)
_TEMP EQU $C000
; Compteur d'input
_INPUT_COUNTER EQU $C002
_INPUT_LAST EQU $C010


;INFORMATIONS CONCERNANT LE JOUEUR
; A noter que les 4 premiers sprites de l'OAM sont réservés au joueur

;Points de vie du joueur
_PLAYER_LIFE EQU $C003
;Informations concernant l'animation du joueur bit 0->direction, bit 1->moved, bit 2->inversion
; Ce qui nous donne pour la direction le schéma suivant (une fois ANIMATION and DIRECTION)
; 0 -> down (0 vertical)
; 1 -> up (inversion de down)
; 4 -> left (0 horizontal)
; 5 -> right (inversion de left)
_PLAYER_ANIMATION EQU $C007
_PLAYER_MOVED EQU %10
_PLAYER_DIRECTION EQU %101
;Adresse de l'index de frame du joueur
_PLAYER_FRAME EQU $C004
;X et Y du joueur (x=_PLAYER_POS et y=_PLAYER_POS) $C006 est réservé
_PLAYER_POS EQU $C005
;Vitesse du joueur
_PLAYER_MOVE_SPEED EQU 1
;index du premier sprite du joueur
_PLAYER_SPRITE_INDEX EQU $80
_PLAYER_ROOM EQU $C008


;INFORMATIONS CONCERNANT LE DONJON
;Debut des infos sur le donjon, chaque salle est écrite sur 6 bytes
; 1 byte -> w et h de la salle
; 2 byte -> doors meta 4*2 bits (00 pas de porte, 01 pos*1, 10 pos*2, 11 pos*2+1)
; 3 byte -> doors pos
; 4 byte -> destination de la porte 1 et 2
; 5 byte -> destination de la porte 3 et 4
; 6 byte -> inutile
_DUNGEON_DATA EQU $C020
_DUNGEON_MAX_ROOMS EQU 10
_ROOM_MAX_SIDE EQU 5

;INFORMATIONS RELATIVES AUX CELLULES
_CELL_GROUND_EMPTY EQU 1

_CELL_WALL_H_OVER EQU 7
_CELL_WALL_H EQU 8
_CELL_WALL_V EQU 2

_CELL_DOOR_L EQU $C
_CELL_DOOR_T EQU $9
_CELL_DOOR_R EQU $A
_CELL_DOOR_B EQU $B



        ENDC
