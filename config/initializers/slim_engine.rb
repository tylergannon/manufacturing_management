# frozen_string_literal: true
Slim::Engine.set_options shortcut: {
  '@' => { attr: 'role' },
  '#' => { attr: 'id' },
  '.' => { attr: 'class' },
  '$' => { tag: 'button', attr: 'type' }

}
