sprite:
; Libère un emplacement de sprite
; hl emplacement à libérer
.free: 
  ld a, 0
  ldi [hl], a ; y
  ldi [hl], a ; x
  ldi [hl], a ; tile
  ldi [hl], a ; flag
  ret
  
; Cherche un emplacement de sprite libre 
; return hl
.search_free: 
  push bc
  push de
  ld hl, OAM_START
  ld b, 0 ; compteur 
  .search_free_loop:
    ; Si hl sorti de OAM    
    ld a, b 
    cp 40 ; est ce qu'on a fait le tour des 40 emplacement ? 
    jr z, .search_free_exit
    ld c, [hl] ; position y
    inc hl 
    inc hl 
    inc hl 
    inc hl
    ; comparaison à zéro
    xor a ; raz
    or c 
    cp 0
    jr nz, .search_free_loop
    dec hl 
    dec hl 
    dec hl 
    dec hl
    jp .search_free_end
    .search_free_exit:
      ld hl, 0 ; si on a rien trouvé on met hl à 0
  .search_free_end:
    pop de
    pop bc 
    ret

; Fait apparaitre un sprite à l'écran
; b position x
; c position y
; d tile number 
; e flags 
.spawn:
  call .search_free
  ld a, b 
  ldi [hl], a 
  ld a, c 
  ldi [hl], a 
  ld a, d 
  ldi [hl], a 
  ld a, e 
  ldi [hl], a 
  ; on remets hl à la valeut initiale de la position dans l'OAM
  dec hl 
  dec hl 
  dec hl 
  dec hl
  ret

; déplace un sprite
; hl doit contenir l'adresse OAM
; b position x 
; c position y
.move: 
  push hl

  ld a, c 
  ldi [hl], a
  ld a, b
  ldi [hl], a

  pop hl
  ret

; Retourne l'adresse de la structure de spritegroup valide
.get_group_address: 
  ld hl, SPRITEGROUPS_START
  ld a, [SPRITEGROUPS_SIZE]
  ; vérification initiale, si a = 0 pas besoin de continuer 
  cp 0 
  jr z, .get_group_address_end
  .get_group_address_loop:
    ; on augmente hl de 4 bytes
    inc hl 
    inc hl
    inc hl 
    inc hl 
    dec a 
    cp 0
    jr nz, .get_group_address_loop
  .get_group_address_end: 
    ret

; Crée un groupe de sprites qui pourront être contrôlés ensemble
; b tile 1
; c tile 2
; d tile 3
; e tile 4
.create_group
  call .get_group_address ; hl contient l'adresse du groupe
  push bc
  push de 

  ; Gestion sprite 1
  ld d, b
  ld b, 16 
  ld c, 8 
  ld e, 0
  push hl
  call .spawn
  ld c, l
  ; c contient l'adresse OAM du sprite (4 derniers bits)
  pop hl ; hl contient l'adresse RAM du groupe
  ld [hl], c

  ; On restaure et on re-sauve les paramètres
  pop de
  pop bc 
  push bc 
  push de

  ; Gestion sprite 2
  ld d, c
  ld b, 16
  ld c, 8+8
  ld e, %00100000
  push hl 
  call .spawn
  ld c, l 
  pop hl 
  inc hl 
  ld [hl], c

  ; On restaure et on re-sauve les paramètres
  pop de
  pop bc 
  push bc 
  push de

  ; Gestion sprite 3
  ; d a déjà la bonne valeur
  ld b, 16+8
  ld c, 8
  ld e, 0
  push hl 
  call .spawn
  ld c, l 
  pop hl 
  inc hl 
  ld [hl], c

  ; On restaure et on re-sauve les paramètres
  pop de
  pop bc 
  push bc 
  push de

  ; Gestion sprite 3
  ld d, e
  ld b, 16+8
  ld c, 8+8
  ld e, %00100000
  push hl 
  call .spawn
  ld c, l 
  pop hl 
  inc hl 
  ld [hl], c

  pop bc 
  pop de
ret

; Déplace un groupe de sprite 
; hl doit contenir l'adresse du groupe dans la RAM
; b doit contenir nouvelle position x 
; c doit contenir nouvelle position y
.move_group

  ldi a, [hl] ; récupère 4 derniers bits de l'adresse du premier OAM
  push hl 
  ld hl, OAM_START
  ld l, a
  call .move

  pop hl 
  ldi a, [hl]
  push hl 
  ld hl, OAM_START
  ld l, a
  ld a, b 
  add 8 ; on décale de 8 pixels vers la droite
  ld b, a
  call .move

  pop hl 
  ldi a, [hl]
  push hl 
  ld hl, OAM_START
  ld l, a
  ld a, b 
  sub 8 ; on décale de 8 pixels vers la gauche
  ld b, a
  ld a, c
  add 8 ; on décale de 8 pixels vers le bas
  ld c, a
  call .move

  pop hl 
  ldi a, [hl]
  ld hl, OAM_START
  ld l, a
  ld a, b 
  add 8 ; on décale de 8 pixels vers la droite
  ld b, a
  call .move
  
ret