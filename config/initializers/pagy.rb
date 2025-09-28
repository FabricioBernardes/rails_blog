require "pagy/extras/overflow"
require "pagy/extras/array"

Pagy::DEFAULT[:items] = 10
Pagy::DEFAULT[:size]  = [ 1, 4, 4, 1 ]
Pagy::DEFAULT[:overflow] = :last_page
