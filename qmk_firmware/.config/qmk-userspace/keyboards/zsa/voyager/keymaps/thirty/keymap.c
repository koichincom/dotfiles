// clang-format off
#include QMK_KEYBOARD_H

#define XXX KC_NO
#define ___ KC_TRNS

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [0] = LAYOUT(
    XXX, XXX , XXX , XXX , XXX , XXX ,     XXX , XXX , XXX    , XXX   , XXX    , XXX,
    XXX, KC_Q, KC_W, KC_F, KC_P, KC_B,     KC_J, KC_L, KC_U   , KC_Y  , KC_SCLN, XXX,
    XXX, KC_A, KC_R, KC_S, KC_T, KC_G,     KC_M, KC_N, KC_E   , KC_I  , KC_O   , XXX,
    XXX, KC_Z, KC_X, KC_C, KC_D, KC_V,     KC_K, KC_H, KC_COMM, KC_DOT, KC_SLSH, XXX,
                      KC_BSPC, KC_SPC,     KC_TAB, KC_ENT
  ),
};
