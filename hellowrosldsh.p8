pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- qui salviamo gli indici degli sprite dei simboli
-- nota: li ho salvati come stringhe solo per debuggare
s1 = 9
s2 = 10
s3 = 11
s4 = 12

-- qui salviamo gli indici dei colori
c1 = 7
c2 = 8
c3 = 9
c4 = 10

-- creates a char
function make_char(spr_id, c, w, x, y)
	local char = {}
	char.sprite = spr_id
	char.col = c
	char.x = w.x + x
	char.y = w.y + y
	char.show = true
	return char
end

-- make_word(planet)
-- word = {
--		x
--		y
--		chars[]

---- rules
-- rule: add generic symbol
function append(word, sym, c)
	word.chars[count(word.chars) + 1] = 
	 make_char(sym, c, word, count(word.chars) * 8, 0)
	recenter_word(word)
 squeeze_chars(word)
end

-- rule: swap first and last letter
function swap(word, offset)
	if(count(word.chars) <= 1) then
	 return
	end
	local sprite_a = word.chars[count(word.chars) - offset].sprite
	local col_a = word.chars[count(word.chars) - offset].col
	word.chars[count(word.chars) - offset].sprite = word.chars[1 + offset].sprite
	word.chars[1 + offset].sprite = sprite_a
	word.chars[count(word.chars) - offset].col = word.chars[1 + offset].col
	word.chars[1 + offset].col = col_a
end

-- rule: remove last letter
function remove_last(word)
	word.chars[count(word.chars)] = nil
	recenter_word(word)
 squeeze_chars(word)
end

-- rule: revert message
function revert_word(word)
	local r = {}
	for i=0,count(word.chars) - 1 do
		r[i+1] = {}
		r[i+1].sprite = word.chars[count(word.chars) - i].sprite
		r[i+1].col = word.chars[count(word.chars) - i].col
	 r[i+1].x = word.chars[i+1].x
	 r[i+1].y = word.chars[i+1].y
	 r[i+1].show = word.chars[i+1].show
	end
	word.chars = r
end

-- rule: filter color
function filter_color(word, filtered)
 i = 1
 while i <= count(word.chars) do
  if word.chars[i].col == filtered then
   del(word.chars, word.chars[i])
  else
   i += 1
  end
 end
 recenter_word(word)
 squeeze_chars(word)
end

-- recalculate all chars position in word
function squeeze_chars(word)
 for i = 1,count(word.chars) do
  word.chars[i].x = word.x + (i - 1) * 8
  word.chars[i].y = word.y
 end
end

-- recenter word passed as arg
function recenter_word(word)
 word_width = 8 * count(word.chars)
 word.x = (word.planet.x) - word_width / 2
end
-- saves the rules into an array
rule_set = { 
 function (word) return swap(word, 0) end, -- swap first and last char
 function (word) return swap(word, 1) end, -- swap second and third char
 remove_last, -- remove last char
	revert_word, -- revert word

 -- append s1 in all colors
 function (word) return append(word, s1, c1) end, 
 function (word) return append(word, s1, c2) end,
 function (word) return append(word, s1, c3) end,
 function (word) return append(word, s1, c4) end,

 -- append s2 in all colors
 function (word) return append(word, s2, c1) end,
 function (word) return append(word, s2, c2) end,
 function (word) return append(word, s2, c3) end,
 function (word) return append(word, s2, c4) end,

 -- append s3 in all colors
 function (word) return append(word, s3, c1) end,
 function (word) return append(word, s3, c2) end,
 function (word) return append(word, s3, c3) end,
 function (word) return append(word, s3, c4) end,

 -- append s4 in all colors
 function (word) return append(word, s4, c1) end,
 function (word) return append(word, s4, c2) end,
 function (word) return append(word, s4, c3) end,
 function (word) return append(word, s4, c4) end,

 -- filter colors
 function (word) return filter_color(word, c1) end,
 function (word) return filter_color(word, c2) end,
 function (word) return filter_color(word, c3) end,
 function (word) return filter_color(word, c4) end,
}

-- returns a copy of an existent word
function copy_word(word)
 local copy = {chars = {}}
 for i=1,count(word.chars) do
  copy.chars[i] = {
   sprite = word.chars[i].sprite, 
   col = word.chars[i].col, 
   x = word.chars[i].x, 
   y = word.chars[i].y,
   show = word.chars[i].show
  }
 end
 copy.x = word.x
 copy.y = word.y
 copy.planet = word.planet
 return copy
end

-- applies the rule of given index
function apply_rule(word, rule)
 -- creates a copy of the word
 local new_word = copy_word(word)
 -- applies rule on the copy
	rule_set[rule](new_word)
 return new_word
end


-- create a new word
-- the word object is required
-- for character creation
function make_word(p,ox, oy, chars)
 word  = {}
 word.planet = p
 word.x = p.x + ox
 word.y = p.y + oy
 return word
end

-- draw a word of the chosen
-- color on screen
function draw_word(w,keep_visible)
 for c in all(w.chars) do
  if c.show then
   pal(7, c.col)
   
   x = pan(c.x)
   if (keep_visible) do
    visible_wx = max(pan(w.x),0)
    visible_wx = min(visible_wx,100-#word.chars)
    
    x = (c.x)-w.x+visible_wx
   end
   
   spr(c.sprite, x, c.y)
  end
 end
 pal()
end
-->8
---------------------
-----story section
-----------------------
-- all users possible
-- sentences

opts = {
 good = {
  "salutations my fellow planet",
  "2242 sagot here: peace",
  "your moms are nice ladies",
  "ave, globe!",
  "we will be your allies",
  "imagine there's no planets"
 },
 bad = {
  "prepare to bow down to us",
  "you won't ever control us",
  "you underestimate our power!",
  "supercazzola prematurata x2",
  "soundtest incoming: 'beeeep'",
  "we have a big red button!"
 }
}

-- factions
-- 1 --> religious
-- 2 --> merchants
-- 3 --> imperials
-- 4 --> neutrals

facti_msgs = {
 -- fact 1
 {
  good = {
   "on behalf of my god i bring you salutations.",
   "pleased by your polite greetings.",
   "may our god bless you 20242 sagot.",
   "good morning to you... even if it is not a good morning.",
   "i send greetings of peace from the tombs of the anchestors.",
   "i address particular greetings to the faithful.",
  },
  bad = {
   "yeah you can attack us this cannot make this day worse... but we will defend ourselves.",
   "do not push the will of our god.",
   "neither our best monks can believe your word.",
   "what you said about our ugly face is true we know...",
   "do not dare our god.",
   "why are you naming my lord in vain?",
  }
 },
 -- fact 2
 {
  good = {
   "have a good day 20242 sagot. if you need anything just let us know.",
   "the greetings from a merchant.",
   "zuorfapaf!",
   "well let us offer our greetings. we will be pleased to provide you all supplies you need.",
   "greetings! we will be please to play astro-golf with you next week.",
   "hi 20242 sagot finally you have the radio. do you need anything?",
   "hello we are a planet from the mercantile confederation.",
   "we are friend of everyone who is friend of the mercantile confederation."
  },
  bad = {
   "this is a very bad idea. this way we will be obliged to attack you.",
   "our business affairs will lead us to engage war with you.",
   "quaiertaan nani?",
   "...",
   "don't fool with us you are a small nothing in the universe.",
   "your trades won't profit from this.",
   "a shrewd merchant would not use these words.",
   "this is an unfair trade my dear."
  }
 },
 -- fact 3
 {
  good = {
   "our government sends his warmest greetings.",
   "the chancellor sends his greetings.",
   "the chancellor welcome evety visitor with a warm greeting.",
   "how r u doin'?",
   "mesa your humble servant!",
   "hoc prudentiam tuam hoc eruditionem decet.",
   "hi.",
   "greetings from the chancellor. (wow!)",
  },
  bad = {
   "i'm going to make you an offer you can't refuse.",
   "r u mad, man?",
   "dissen gonna be bery messy!",
   "quo usque tande pazienza nostra abuterent?",
   "our torturers cannot wait to let your soul leave your body.",
   "there is a special cellar for people talking like this: yes a very special one...",
   "our mothers what? do we have to come over?",
   "a thai-fighter is taking off.",
  }
 },
 -- fact 4
 {
  good = {
   "you can come and eat with us.",
   "hello and good morning farmer 20242 sagot.",
   "we offer only happiness and good greetings.",
   "yo! you get friend / in this far land / we're here to help / but don't mess yourself.",
   "hello :)",
   "we will extend our hand as a greeting.",
   "warm regards stranger.",
   "nice another asshole planet. wait did you send it?",
   "hey there! :d",
  },
  bad = {
   "mamma mia! what did that message mean?",
   "please write something meaningful.",
   "man please don't say / those things today / we also may / send you some knaves.",
   "i don't really think our mothers will do that.",
   "you should really and seriously think about what you just said.",
   "once we tried it, and it was not a good idea.",
   "it sounds as fair as taking epilectics to the disco.",
   "you should behave yourself, kid."
  }
 }
}

-- planets_name_array
planet_names = {
 "kebrade",
 "shazatania",
 "uytera",
 "sesca carro",
 "keater",
 "stier 81",
 "arastellia",
 "enodeis",
 "steatis",
 "archaus",
 "chorix 4q59",
 "firiri op",
 "bluestea",
 "pruna",
 "vegaroo",
 "charvis p2" 

}

-- planet_faction_array
planet_factions = {3,4,1,2,4,2,1,1,4,3,3,2,4,4,2,3}

-- get a random option for the
-- prompt

function get_rand_option(good_opt)
 if (good_opt == true) then
  return opts.good[rndi(count(opts.good))]
	else
		return opts.bad[rndi(count(opts.bad))]
 end
end

-- get a random planet name
function get_rand_planetname()
 return planet_names[rndi(count(planet_names))] 
end

-- get the faction of planet with name
function get_planet_faction(pname)
 for i=1,count(planet_names) do
  if planet_names[i] == pname then
   return planet_factions[i]
  end 
 end
end

function split_msg(msg, chars_per_line)
 splitted_msg = {"","",""}
 splitted_msg[1] = msg
 if #msg > chars_per_line then
  splitted_msg[1] = sub(msg, 1, chars_per_line)
  splitted_msg[2] = sub(msg, chars_per_line + 1, #msg)
 end
 if #splitted_msg[2] > chars_per_line then
  local tmp = splitted_msg[2]
  splitted_msg[2] = sub(tmp, 1, chars_per_line)
  splitted_msg[3] = sub(tmp, chars_per_line + 1, #tmp) 
 end
 return splitted_msg
end

function get_rand_message(faction, good_msg)
 if (good_msg == true) then
  return split_msg(facti_msgs[faction].good[rndi(count(facti_msgs[faction].good))], 28)
	else
		return split_msg(facti_msgs[faction].bad[rndi(count(facti_msgs[faction].bad))], 28)
 end
end

--------------
-----endless story------
-----------





-- particles
function make_sparkle(x,y,frame,col)
 local s = {}
 s.x=x
 s.y=y
 s.frame=frame
 s.col=col
 s.t=0 s.max_t = 8+rnd(4)
 s.dx = 0 s.dy = 0
 s.ddy = 0
 add(sparkles,s)
 return s
end
function move_sparkle(sp)
 if (sp.t > sp.max_t) then
  del(sparkles,sp)
 end
 sp.x = sp.x + sp.dx
 sp.y = sp.y + sp.dy
 sp.dy= sp.dy+ sp.ddy
 sp.t = sp.t + 1
end
function draw_sparkle(s)
 if (s.col > 0) then
  for i=1,15 do
   pal(i,s.col)
  end
 end
 spr(s.frame, pan(s.x-2), s.y-2)
 pal()
end

-- rnd on a pos/neg range
function rndr(v) 
 return flr(v/2+rnd(v))
end

function rndi(mx)
 return 1+flr(rnd(mx))
end



function panat(x)
 return 64-x
end

function pan(v) 
 return v + pan_x
end

function draw_planet_selection(p, strength)
 x = pan(p.x)
 
 size = p.size+2
 col = sin(t)*1+11
 if (strength == 1) then
  size += 1
  col =sin(t)*1+9
 elseif (strength == 2) then
  size += 1
  col =sin(t)*1+11
 end
 
 circfill(x,p.y,size,col)
   
end


flag_allied = 1
flag_enemy = -1
function draw_feedback(p)
  x = pan(p.x)

  -- no draw
  if (p == home_planet)do
   return
  end
  if (p == trgt_p)do
   return
  end
    
  -- rule feedback
  local r = p.rule
  
  r_spr = 84
  if (r == 1) then
   r_spr = 81
  elseif (r==2) then
   r_spr = 83
  elseif (r==3) then
   r_spr = 85
  elseif (r==4) then
   r_spr = 6
  elseif (r>=5 and r<=20) then
   r_spr = 82
  else
   r_spr = 97
  end
  
  c = {}
  c.show = true
  c.col = c4
  c.sym = s2
  if (r == 1) then
  	c.show = false
  elseif (r==2) then
  	c.show = false
  elseif (r==3) then
  	c.show = false
  elseif (r==4) then
  	c.show = false
  elseif (r>=5 and r<=8) then
   c.sym = s1
   if (r == 5) then
    c.col = c1
   elseif (r == 6) then
    c.col = c2
   elseif (r == 7) then
    c.col = c3
   else
    c.col = c4
   end
  elseif (r>=9 and r<=12) then
   c.sym = s2
   if (r == 9) then
    c.col = c1
   elseif (r == 10) then
    c.col = c2
   elseif (r == 11) then
    c.col = c3
   else
    c.col = c4
   end
  elseif (r>=13 and r<=16) then
   c.sym = s3
   if (r == 13) then
    c.col = c1
   elseif (r == 14) then
    c.col = c2
   elseif (r == 15) then
    c.col = c3
   else
    c.col = c4
   end
  elseif (r>=17 and r<=20) then
   c.sym = s4
   if (r == 17) then
    c.col = c1
   elseif (r == 18) then
    c.col = c2
   elseif (r == 19) then
    c.col = c3
   else
    c.col = c4
   end
  else
   c.show = false
  end
  
  
  -- diplomacy changes feedback
  if (p.allied == flag_allied) do
   r_spr = 3
   c.show = false   
  end
  if (p.allied == flag_enemy) do
   r_spr = 4
   c.show = false
  end
  
  dx = 0
  if (c.show == true) then
   dx = 4
  end
  
  off_y = p.size+6
  
  pal()
  if (r == 21) then
    pal(8, c1)
  elseif (r == 22) then
    pal(8, c2)
  elseif (r == 23) then
    pal(8, c3)
  elseif (r == 24) then
    pal(8, c4)
  end
  spr(r_spr,x-4+dx,p.y-4+off_y)
  pal()
  
  if (c.show == true) then
   c.x = x-4-4
   c.y = p.y-4+off_y 
   pal(7, c.col)
   spr(c.sym, (c.x), c.y)
   pal()
  end
  
end

function draw_planet(p)
  x = pan(p.x)
  circfill(x,p.y,p.size+1,p.c[3])
  circle_sq(x,p.y,p.size,p.c[2])
  circfill(x-1,p.y-1,p.size-1,p.c[2])
  circle_sq(x-2,p.y-2,p.size-4,p.c[1])
  circfill(x-4,p.y-4,p.size-6,p.c[1])

  --print(p.rule,x,p.y,7)

end


explosion_t = 0
explosion_phase = 0
function draw_explosion()
  explosion_t += 1/30.0
  
  p = home_planet
  
  for i=1,16 do
   s = make_sparkle(p.x,p.y,18,0)
   s.dy = 1*sin(i/16.0)
   s.dx = 1*cos(i/16.0)
   s.max_t = 30*8
  end
  
  for i=1,16 do
   s = make_sparkle(p.x,p.y,18,8)
   s.dy = 2*sin(i/16.0)
   s.dx = 2*cos(i/16.0)
   s.max_t = 30*8
  end
  
end

--- game over
function check_gameover()
 
 --if (true) then
 if (n_enemies >= n_enemies_gameover) then
  fsm = fsm_gameover
  draw_explosion()
  music(12)
 
 end
end

function update_alliances()
 n_enemies = 0
 n_allied = 0
 for p in all(graph) do
   
  -- vary state with diplomacy
  if p.diplomacy <= -0.75 then 
   p.allied = flag_enemy
  elseif p.diplomacy >= 0.75 then
   p.allied = flag_allied
  else 
   p.allied = 0
  end
  
  if (p.allied == flag_enemy) then
   n_enemies+=1
  elseif (p.allied == flag_allied) then
   n_allied+=1
  end
 end

end


tgt_diplomacy_step = 0.4
tgt_faction_diplomacy_step = 0.2
error_all_step = 0.1
others_laugh_step = 0.2
diplomacy_bar_time = 3 * 30 -- each second is 30 frames
function send_result(correct_msg, timedout, planets)
 
 fsm = fsm_receive
   
 intent = ui_selection == 2
 
 -- xor power!
 answer_good = false
 if (correct_msg and intent) then
  answer_good = true
 --elseif (res and not intent) then
 -- answer_good = false
 elseif(not res and not intent) then
  answer_good = true
 --elseif(not res and intent) then
 -- answer_good = false
 end
 
 if timedout then
  answer_good = false
 end
 
 
 error_made = timedout or not correct_msg
 
 
 if error_made then
  -- the msg did not arrive at all correctly
  -- everything decreases!
  
  -- the target gets always angry
  trgt_p.diplomacy = mid(trgt_p.diplomacy - tgt_diplomacy_step, -1, 1)
  
  -- all other planets get a little angrier
  for i=1,count(planets) do
    p = planets[i]
    if (p != home_planet) then
     p.diplomacy = mid(p.diplomacy - error_all_step, -1, 1)
     p.dip_bar_visible = true
     p.dip_bar_timer = diplomacy_bar_time
   end
  end
  
  -- rnd one
  --do
  -- rnd_p = planets[rndi(planets)]
  --until (rnd_p != trgt_p)
  
 
 else 
  
  -- the msg arrived, they react
  if answer_good then
   -- target is happy
   trgt_p.diplomacy = mid(trgt_p.diplomacy + tgt_diplomacy_step, -1, 1)
   
   -- his faction is a lil happy
   for i=1,count(planets) do
    f_pl = planets[i]
    if f_pl.faction == trgt_p.faction then
     f_pl.diplomacy = mid(f_pl.diplomacy + tgt_faction_diplomacy_step, -1, 1)
     f_pl.dip_bar_visible = true
     f_pl.dip_bar_timer = diplomacy_bar_time
    end
   end
  else
  
   -- target is angry
   trgt_p.diplomacy = mid(trgt_p.diplomacy - tgt_diplomacy_step, -1, 1)

   -- his faction is a lil angry
   for i=1,count(planets) do
    f_pl = planets[i]
    if (f_pl != home_planet) then 
     if f_pl.faction == trgt_p.faction then
      f_pl.diplomacy = mid(f_pl.diplomacy - tgt_faction_diplomacy_step, -1, 1)
      f_pl.dip_bar_visible = true
      f_pl.dip_bar_timer = diplomacy_bar_time
     else
      -- all others are a lil happier
      f_pl.diplomacy = mid(f_pl.diplomacy + others_laugh_step, -1, 1)
      f_pl.dip_bar_visible = true
      f_pl.dip_bar_timer = diplomacy_bar_time
     end
     
    end
   end
   
   
 end
 
 end
 trgt_p.dip_bar_visible = true
 trgt_p.dip_bar_timer = diplomacy_bar_time
 -- txts for receiving
 --print(trgt_p.name)
 --print(trgt_p.faction)
 
 update_alliances()
 check_gameover()

 if (fsm == fsm_receive) do
 
  answer_msg = get_rand_message(trgt_p.faction,answer_good)
  txts[1] = answer_msg[1]
  txts[2] = answer_msg[2]
  txts[3] = answer_msg[3]
  
  sfx_answer()
 
 end
 
end

function timeout()
 send_result(false,true,graph)
end

timer = 0
max_timer = 60
function draw_timer()
 timer += 1/30.0
 alpha = 1-timer*1.0/max_timer
 if (timer >max_timer*0.75  and flr(timer*10)%2 == 0)do
  rectfill(0,126,128*alpha,128,7)
 else
  rectfill(0,126,128*alpha,128,8)
 end
 
 -- death
 if (timer >= max_timer) do
 	timer = 0
 	timeout()
 end
 
end


stars = {}
function draw_starfield()
 if (count(stars) == 0) do
  for i = 1,256 do
   stars[i] = rnd(128)   
  end
 end
 for i = 1,256 do 
  pset(
   pan(i+t*(i%5))%256,
   stars[i],
   2+sin(0.5*t+0.1*i*2)
  )
 end
end

-- draws a diplomacy bar
-- should be called in _draw (maybe from draw_planet()?)
-- note: width must be an odd number
-- planet.diplomacy must be in [-1, +1]
function draw_diplomacy_bar(planet, ox, oy, width, height)
	x = flr(pan(planet.x)) + ox
	y = flr(planet.y) + oy
 -- draws empty bar
 local h_w = width / 2
 rectfill(x+1 - h_w, y + height, x + h_w - 1, y, 2)
 -- draws the actual bar
 local len = flr(h_w * planet.diplomacy) - sgn(planet.diplomacy)
 if (planet.diplomacy > 0) then
  c = 11
 else
  c = 8
 end
 if planet.diplomacy != 0 then
 	rectfill(x, y + height, x + len, y, c)
 end
 -- draws center
 rectfill(x, y + height, x, y, 7)
 spr(128, flr(x - (width / 2) - 10), y - 2)

 -- faction
 --planet.faction
 if (planet.faction == 1) then
  pal(7,11)
 elseif  (planet.faction == 2) then
  pal(7,12)
 elseif  (planet.faction == 3) then
  pal(7,13)
 elseif  (planet.faction == 4) then
  pal(7,14)
 end
 
 spr(22, x + 8, y - 2)
 pal()

end

ruletypes = {}
ruletypes[5] = {1,2}
ruletypes[2] = {3}
ruletypes[4] = {4}
ruletypes[1] = {5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20}
ruletypes[3] = {21,22,23,24}

function get_rule(p) 
 rtype = ruletypes[rndi(difficulty)]
 return rtype[rndi(count(rtype))] 
end


-- star map creation
function create_graph(x,y) 
 --srand(1)
 colors = {}
 colors[1] = {9,4,2}
 colors[2] = {7,6,5}
 colors[3] = {11,3,5}
 colors[4] = {8,9,10}
 graph = {}
 for i=1,x do
  for j=1,y do
   -- create planet
   p = {}
   p.index = i+j*x
   p.i = i-1
   p.j = j-1
   p.x = (i-1)*span_x + rndr(10)
   p.y = (j-1)*span_y + rndr(12)
   p.y = min(100,max(20,p.y))
   
   
   p.size = 4+rnd(5)
   p.c = colors[rndi(4)]
   p.rule = get_rule(p)
   
   -- strategic overlay properties
   p.name = get_rand_planetname()
   p.faction = get_planet_faction(p.name)
   p.diplomacy = 0
   p.allied = 0
			p.dip_bar_visible = false
			p.dip_bar_timer = 0
   
   -- gameplay
   p.angry = false
   if (rnd(100) < 50) p.angry = true
   
   add(graph,p)
  end
 end
 return graph
end

-- current selection
function get_planet(i,j)
 return graph[1+i*size_y+j]
end

function get_selected()
 return get_planet(sel_i,sel_j)
end


-- stack
function create_stack()
	stack = {}
	stack.pointer = 1
	stack.list = {}
	return stack
end
function push(st,v)
 add(st.list,v)
 st.pointer += 1
end
function pop(st)
 if(st.pointer > 1) do
  st.pointer-=1
 	ret = st.list[st.pointer]
 	del(st.list,ret)
 end
end

-- circle with squared pattern
function circle_sq(x,y,r,c)
  fillp(0b0101101001011010.1)
  circfill(x,y,r,c)
  fillp()
end

line_t = 0
function moving_line(x1,x2,y1,y2,alpha)

x1 = x1+pan_x
x2 = x2+pan_x

dx = x2-x1
dy = y2-y1
line_t += 1/30.0
alpha = line_t%1

circfill(x1+ dx*alpha,
y1+dy*alpha,2+sin(t*3)*1,sin(t)*1+11)

end

-- words

function assign_word(w,p)
  w.x = p.x-15
  w.y = p.y-8-p.size
  w.planet = p
  recenter_word(w)
  squeeze_chars(w)
end

function print_word(w)
 for c in all(w.chars) do
  print(c.sprite)
 end
end

function match_words(w1,w2)
 if(count(w1.chars) != count(w2.chars))do
  return false
 end
 
 for i=1,count(w1.chars) do
  if (w1.chars[i].sprite != w2.chars[i].sprite) do
   return false
  end
  if (w1.chars[i].col != w2.chars[i].col) do
   return false
  end
 end
 
 return true

end



-->8

anim_set = {}
anim_status_idle = 0
anim_status_running = 1
anim_status_finished = 2

anim_curr_status = anim_status_idle

curr_anim				 = nil
anim_complete = false

swap_step = 0
swap_y_offset = 8
swap_start_lx = 0
swap_start_rx = 0
swap_start_y = 0

anim_temp_word = nil

-- swap animation
function swap_anim(word, offset)
 if(swap_step == 0) then
  local left_idx = 1 + offset
  local right_idx = count(word.chars) - offset
  if left_idx > right_idx then
   local a = right_idx
   right_idx = left_idx
   left_idx = a
  end
  left = word.chars[left_idx]
  right = word.chars[right_idx]
  x_offset = (right.x - left.x) * 8
 	swap_start_lx = left.x
 	swap_start_rx = right.x
 	swap_start_y = left.y
 	swap_step = 1
  if (swap_start_rx == swap_start_lx) then
   -- left and right are the same: skip
   swap_step = 3
  end
 elseif(swap_step == 1) then
  if(left.y == swap_start_y-8) then
   swap_step = 2
  else
  	left.y -= 1
  	right.y += 1
  end
 elseif(swap_step == 2) then
  if(left.x == swap_start_rx) then
   swap_step = 3
  else
   left.x += 1
   right.x -= 1
  end
 else
  if(left.y == swap_start_y) then
   anim_complete = true
   swap_step = 0
   print("swapper finito")
  else
   left.y += 1
  	right.y -= 1
 	end
	end
	word.chars[1 + offset] = left
	word.chars[count(word.chars) - offset] = right
end

-- state flags for add animation
add_char_step = 0
char_to_add = nil
char_to_add_dst = 0
delta_time = 1.0 / 30.0

-- animation for appending a new char at the end of the word
function add_char_anim(word, sym, col)
 if add_char_step == 0 then
  -- spawn a char in the expected position and memorize the position
  char_to_add = make_char(sym, col, word, count(word.chars) * 8, 0)
  word.chars[count(word.chars) + 1] = char_to_add
  recenter_word(word)
  squeeze_chars(word)
  char_to_add_dst = {x = char_to_add.x, y = char_to_add.y }

  -- moves the new char to the starting position
  char_to_add.x = word.planet.x
  char_to_add.y = word.planet.y
  new_c_dir_x = char_to_add_dst.x - char_to_add.x
  new_c_dir_y = char_to_add_dst.y - char_to_add.y
  add_char_step = 1
 elseif add_char_step == 1 then
  if char_to_add.x >= char_to_add_dst.x and char_to_add.y <= char_to_add_dst.y then
   anim_complete = true
   add_char_step = 0
  else
   char_to_add.y = mid(char_to_add.y + delta_time * 2 * new_c_dir_y,
    char_to_add.y, char_to_add_dst.y)
   char_to_add.x = mid(char_to_add.x + delta_time * 2 * new_c_dir_x,
    char_to_add.x, char_to_add_dst.x)
  end
 end
end


remove_anim_step = 0
remove_anim_frags = {}
function remove_char_anim(word, index)
 if remove_anim_step == 0 then
  
  if #word.chars == 0 then
 	 anim_complete = true
 	 return
  end
  
  char_to_remove = word.chars[index]
  --remove_anim_frags = {}
  --remove_anim_frags[1] = make_char_frag(char_to_remove, 5, -5)
  --remove_anim_frags[2] = make_char_frag(char_to_remove, 5, 5)
  --remove_anim_frags[3] = make_char_frag(char_to_remove, -5, 5)
  --remove_anim_frags[4] = make_char_frag(char_to_remove, -5, -5)
  --remove_anim_frags[5] = make_char_frag(char_to_remove, 5, 0)
  --remove_anim_frags[6] = make_char_frag(char_to_remove, 0, 5)
  --remove_anim_frags[7] = make_char_frag(char_to_remove, -5, 0)
  --remove_anim_frags[8] = make_char_frag(char_to_remove, 0, -5)
  add_frag_set(char_to_remove)
  remove_anim_step = 1
  char_to_remove.show = false
  frag_timer = 0
 else
  if frag_timer >= 60 then
   anim_complete = true
   remove_anim_frags = {}
   remove_anim_step = 0
  else
   --move_frag_sets()
   frag_timer += 1
   --move_char_frag(remove_anim_frags[1], 2, -2)
   --move_char_frag(remove_anim_frags[2], 2, 2)
   --move_char_frag(remove_anim_frags[3], -2, 2)
   --move_char_frag(remove_anim_frags[4], -2, -2)
   --move_char_frag(remove_anim_frags[5], 2, 0)
   --move_char_frag(remove_anim_frags[6], 0, 2)
   --move_char_frag(remove_anim_frags[7], -2, 0)
   --move_char_frag(remove_anim_frags[8], 0, -2)
  end
 end
end

-- adds the frag set to the main list
function add_frag_set(origin)
 add(remove_anim_frags, make_char_frag(origin, 5, -5))
 add(remove_anim_frags, make_char_frag(origin, 5, 5))
 add(remove_anim_frags, make_char_frag(origin, -5, 5))
 add(remove_anim_frags, make_char_frag(origin, -5, -5))
 add(remove_anim_frags, make_char_frag(origin, 5, 0))
 add(remove_anim_frags, make_char_frag(origin, 0, 5))
 add(remove_anim_frags, make_char_frag(origin, -5, 0))
 add(remove_anim_frags, make_char_frag(origin, 0, -5))
end

frag_move_lambdas = {
 function (f) return move_char_frag(f, 2, -2) end,
 function (f) return move_char_frag(f, 2, 2) end,
 function (f) return move_char_frag(f, -2, 2) end,
 function (f) return move_char_frag(f, -2, -2) end,
 function (f) return move_char_frag(f, 2, 0) end,
 function (f) return move_char_frag(f, 0, 2) end,
 function (f) return move_char_frag(f, -2, 0) end,
 function (f) return move_char_frag(f, 0, -2) end
}
function move_frag_sets()
 for i=1,count(remove_anim_frags) do
  local rem = i % 8 + 1
  frag_move_lambdas[rem](remove_anim_frags[i])
 end
end

-- creates a char fragment for the remove animation
function make_char_frag(to_remove, x, y)
 return {x = pan(to_remove.x) + x, y = flr(to_remove.y) + y, col = to_remove.col}
end

-- moves a char fragment outside the screen
function move_char_frag(frag, x_offset, y_offset)
 frag.x += x_offset
 frag.y += y_offset
end


-- animation for reverting a word
revert_delta_time = 1.0 / 15.0
revert_anim_step = 0
function revert_word_anim(word)
 if revert_anim_step == 0 then
  recenter_word(word)
  squeeze_chars(word)
  center_x = word.x + count(word.chars) * 4 - 4
  center_y = word.y
  current_angle_1 = 0.5
  current_angle_2 = 0.0
  revert_anim_step = 1
 elseif revert_anim_step == 1 then
  if (current_angle_1 >= 1.0) then
    current_angle_1 = 1.0
    current_angle_2 = 0.5
    for i=1,flr(count(word.chars)/2) do
     rotate_by(word.chars[i], center_x, center_y, current_angle_1)
    end
    for i = flr(count(word.chars)/2) + 1,count(word.chars) do
     rotate_by(word.chars[i], center_x, center_y, current_angle_2)
    end
    anim_complete = true
    revert_anim_step = 0
  else
   for i=1,flr(count(word.chars)/2) do
    rotate_by(word.chars[i], center_x, center_y, current_angle_1)
   end
   for i = flr(count(word.chars)/2) + 1,count(word.chars) do
    rotate_by(word.chars[i], center_x, center_y, current_angle_2)
   end
   current_angle_1 += revert_delta_time
   current_angle_2 += revert_delta_time
  end
 end
end

-- rotates a char around a given center by a given angle
function rotate_by(char, center_x, center_y, angle)
 radius = compute_dist(char.x, char.y, center_x, center_y)
 char.x = center_x + cos(angle) * radius
 char.y = center_y + sin(angle) * radius
end

-- distance between points.
function compute_dist(x1,y1,x2,y2)
 return sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
end

-- function for animating the color filtering in words
filter_anim_step = 0
cf_counter = 1
function color_filter(word, c)
 if filter_anim_step == 0 then
  if word.chars[cf_counter].col == c then
   add_frag_set(word.chars[cf_counter])
   word.chars[cf_counter].show = false
  end
  if cf_counter == count(word.chars) then
   filter_anim_step = 1
   frag_timer = 0
  end 
  cf_counter += 1
 else
  -- state = 1
  if frag_timer >= 50 then
   anim_complete = true
   cf_counter = 1
   remove_anim_frags = {}
   filter_anim_step = 0
  else
   --move_frag_sets()
   frag_timer += 1
  end
 end
end

-- append all animations available
anim_set = {
 function(word) return swap_anim(word, 0) end,
 function(word) return swap_anim(word, 1) end,
 function(word) return remove_char_anim(word, count(word.chars)) end,
 revert_word_anim,

 function(word) return add_char_anim(word, s1, c1) end,
 function(word) return add_char_anim(word, s1, c2) end,
 function(word) return add_char_anim(word, s1, c3) end,
 function(word) return add_char_anim(word, s1, c4) end,

 function(word) return add_char_anim(word, s2, c1) end,
 function(word) return add_char_anim(word, s2, c2) end,
 function(word) return add_char_anim(word, s2, c3) end,
 function(word) return add_char_anim(word, s2, c4) end,

 function(word) return add_char_anim(word, s3, c1) end,
 function(word) return add_char_anim(word, s3, c2) end,
 function(word) return add_char_anim(word, s3, c3) end,
 function(word) return add_char_anim(word, s3, c4) end,

 function(word) return add_char_anim(word, s4, c1) end,
 function(word) return add_char_anim(word, s4, c2) end,
 function(word) return add_char_anim(word, s4, c3) end,
 function(word) return add_char_anim(word, s4, c4) end,

 function(word) return color_filter(word, c1) end,
 function(word) return color_filter(word, c2) end,
 function(word) return color_filter(word, c3) end,
 function(word) return color_filter(word, c4) end
}

function check_anim_progression()
 is_complete = anim_complete
 if (is_complete == true) then
 	anim_complete = false
 	curr_anim = nil
 end
 return is_complete
end

function run_animation(word, rule)
 if anim_set[rule] == nil then
  return apply_rule(word, rule)
 end
 if anim_curr_status == anim_status_idle then
   -- call proper animation handler
   curr_anim = anim_set[rule]
   anim_temp_word = apply_rule(word, rule)
   curr_anim(word)
   anim_curr_status = anim_status_running
 elseif anim_curr_status == anim_status_running then
   -- check curr animation progression
   finished = check_anim_progression()
   if finished == true then
    anim_curr_status = anim_status_idle
    word = anim_temp_word
   else
    if(curr_anim == nil) then
     anim_curr_status = anim_status_idle
     word = anim_temp_word
    else 
     curr_anim(word)
    end
   end
 end
 return word
end
-->8

function sfx_move()
 sfx(0,3,0,1)
end

function sfx_select()
 sfx(0,3,0,2)
end

function sfx_back()
 sfx(0,3,2,2)
end

function sfx_msg()
 sfx(0,3,0,1)
end

function sfx_answer()
 sfx(0,3,8,8)
end


----------- main menu -----------


main_menu_highlight = 1
function draw_main_menu()
 -- draws the map
 map(0, 0, 0, 20, 16, 8)
 -- draws team
 spr(223, 76, 49)
 print("by   kotsi\n", 64, 50, 7)
 print("ggj 2018\n", 64, 60, 7)
 -- draws the menu window
 rect(32, 72, 96, 104, 7)
 print("start game", 40, 80, 7)
 print("credits", 40, 94, 7)
 if main_menu_highlight == 1 then
  spr(207, 33, 78)
 else
  spr(207, 33, 92)
 end
 if btnp(❎) then
  -- selection
  sfx_select()
  if main_menu_highlight == 1 then
   music(0)
   reset_turn()
   return
  else
    fsm = fsm_credits
    return
  end
 elseif btnp(⬆️) then
  -- up
  if main_menu_highlight == 2 then
   main_menu_highlight = 1
   sfx_move()
  end
 elseif btnp(⬇️) then
  -- down
  if main_menu_highlight == 1 then
   sfx_move()
   main_menu_highlight = 2
  end
 end
end

function draw_credits()
 rect(3, 3, 125, 125, 7)
 print("hello wo#!? - by pikotsi", 5, 5, 12)
 print("\ndevelopers:\njacopo essenziale, michele\n pirovano, alessandro tironi\n\n"..
  "art: federica tana\n\n"..
  "story telling: mattia bellini\n\n"..
  "sound: matteo caselli\n\n"..
  "special thanks:\nchristian costanza\npier luca lanzi\n"..
  "\npress ❎ to return to menu", 5, 13, 7)

 if btnp(❎) then
  fsm = fsm_main_menu
  sfx_back()
 end
end
-->8

-- general state
n_allies = 0
n_enemies = 0
difficulty = 0

n_enemies_gameover = 4

-- difficulty increase
function difficulty_increase()
 difficulty = difficulty+1
 difficulty = min(difficulty,5)
 
 steps = difficulty + 1+rndi(2) 
 --steps = 1
 
 for p in all(graph) do
  p.rule = get_rule(p)
 end
 
end



-- graph
size_x = 6
size_y = 3
span_x = 40
span_y = 44
steps = 3+rndi(2)
graph = create_graph(size_x,size_y)

 
-- cursor
sel_i = flr(size_x/2)
sel_j = flr(size_y/2)
home_planet = get_selected()

-- time
t = 0

-- pan
pan_spd = 32*4
pan_x = panat(home_planet.x)
pan_dx = 0

-- particles
sparkles = {}


-- game fsm
fsm_select = 0
--fsm_target = 1
fsm_connect = 2
fsm_send = 3
fsm_receive = 4
fsm_gameover = 5
fsm_main_menu = 6
fsm_credits = 7

txts = {}

fsm = fsm_main_menu
ui_selection = 2


trgt_p = {}
tword = {}
cword = {}



function _init()
 	music(11)
end

function generate_start_word()

 -- generate a random word
 ss = {s1,s2,s3,s4}
 cs = {c1,c2,c3,c4}
 tword = make_word(home_planet, -15, -12 -home_planet.size)
 tword.chars = {
  make_char(ss[rndi(4)], cs[rndi(4)], tword, 0, 0),
  make_char(ss[rndi(4)], cs[rndi(4)], tword, 8, 0),
  make_char(ss[rndi(4)], cs[rndi(4)], tword, 16, 0),
  make_char(ss[rndi(4)], cs[rndi(4)], tword, 24, 0)
	}  
 cword = copy_word(tword)
 
  --print("\nstart c")
  --print_word(cword)
  --print("\nstart t")
  --print_word(tword)
 
 -- travel to the target planet applying rules
 -- won't move on already visited planets
 -- won't get stuck
 
 finished = false
 
 safe_counter = 400
 
 while finished == false do
  visited = {}
  
  tword = copy_word(cword)
  
  trgt_i = sel_i
  trgt_j = sel_j
  error = false
  
  --print("---")

  add(visited,home_planet)
  for i=1,steps do
   r = rnd(100)
   if (r< 25) then trgt_i += 1
   elseif (r<50)then  trgt_j += 1
   elseif (r<75) then trgt_i -= 1
   elseif (r<100) then trgt_j -= 1
   else break end
   
   if (trgt_i < 0 or trgt_j < 0) do
    error = true
   end
   if (trgt_i >= size_x or trgt_j >= size_y) do
    error = true
   end
   
   if (error == false) do
    trgt_p = get_planet(trgt_i,trgt_j) 
    
    for p in all(visited) do
     if (trgt_p == p) do
      error = true
     end
    end
   end
   
   if (error == false) do
    
    -- skip the target
    -- skip allies
    --print(#tword.chars)
    if (i<=steps-1 and trgt_p.allied != flag_allied) do
     tword = apply_rule(tword,trgt_p.rule)
    end
    assign_word(tword,trgt_p)
    add(visited,trgt_p)
    --print("ok")
   else
    --print("ko")
   end
  end
  
  if (error == false) do
   --print("found♪!")
   finished = true
  else
   safe_counter-=1
   if (safe_counter == 0) do
    finished = true
    --print("arghhhhh")
   end
  end 
  
 end
  

  --print(sel_i..","..sel_j)
  --print(trgt_i..","..trgt_j)
  --print("rule: "..trgt_p.rule.."")
  --print("\nc")
  --print_word(cword)
  --print("\nt")
  --print_word(tword)
  
end


function reset_game()

 -- reset alliances
 for p in all(graph) do
  p.diplomacy = 0
  p.allied = 0
 end
 
 n_allies = 0
 n_enemies = 0
 difficulty = 0

end

function reset_turn()
 
 fsm = fsm_select
 ui_selection = 2
 txt_t = 0

 sel_i = home_planet.i
 sel_j = home_planet.j
 
 pass_planets = create_stack()
 push(pass_planets,home_planet)

 difficulty_increase()
 
 generate_start_word()

 -- init selection texts
 txts[1] = "recipient: "..trgt_p.name
 txts[2] = get_rand_option(true)
 txts[3] = get_rand_option(false)

 -- reset timer too
 timer = 0
 
 sparkles = {}
 
 --check_gameover()
end

function draw_ui()
 

 ui_span = 2
 ui_border = 1
 ui_content_x = 9
 ui_content_y = 2
 x_l = ui_span
 x_r = 128-ui_span
 y_d = 128-ui_span
 y_u = 128-ui_span-24
 fsize = 5
 line_span = 2
 rectfill(x_l,x_r,y_d,y_u,7)
 rectfill(x_l+ui_border,
 x_r-ui_border,
 y_d-ui_border,
 y_u+ui_border,5)
 
 
 txt_col = 7
 
 -- scrolling text
 scroll = (fsm == fsm_receive)
 
 txt_t+=1
 t_temp = txt_t
 if (not scroll)  do
  t_temp = 4000
 end
 txt = sub(txts[1],0,t_temp)
 
 print(txt,
 x_l+ui_content_x,
 y_d-ui_content_y-fsize*3-line_span*2,
 txt_col)
 
 if (t_temp > #txts[1]) do
  t_temp -= #txts[1]
  txt = sub(txts[2],0,t_temp)
  print(txt,
  x_l+ui_content_x,
  y_d-ui_content_y-fsize*2-line_span,
  txt_col)
 end
 
 if (t_temp > #txts[2]) do
  t_temp -= #txts[2]
  txt = sub(txts[3],0,t_temp)
  print(txt,
  x_l+ui_content_x,
  y_d-ui_content_y-fsize,txt_col)
 end
 
 if (fsm == fsm_select) do
  -- cursor
  spr(64,x_l,
  y_d-ui_content_y-1
  -fsize*(3-ui_selection+1)
  -line_span*((3-ui_selection)))
  
  if (btnp(⬇️) and ui_selection<3) do
   ui_selection+=1
   sfx_move()
  end
  
  if (btnp(⬆️) and ui_selection>2) do
   ui_selection-=1
   sfx_move()
  end
  
  if (btnp(❎)) do
   -- perform the selection
   fsm = fsm_connect
   
   sel_i = home_planet.i
   sel_j = home_planet.j
   
   sfx_select()
  end
 end
  
 if (fsm == fsm_receive) do

  if (btnp(❎)) do
   -- reset the turn
   reset_turn()
   sfx_select()
  end
 end
  

end

function send_message(planets)
 animation_t = 0
 fsm = fsm_send
end




animation_t = 0
anim_last_i = 0
anim_i = 0

wait_for_anim = false

function animate_message(planets)
 -- move the animated message around
  
 -- each integer of anim_t will be a step
 
 if (not wait_for_anim) do
  animation_t += 1/30.0
 end
 
 anim_last_i = anim_i
 anim_i = flr(animation_t)
 p_seq = 1 + flr(anim_i/2)
  
 if (anim_i % 2 == 0) do
  -- first animate the line
  
  if (p_seq == count(planets)) do
   -- finished animation
   
   send_result(match_words(tword,cword), false, graph)
   return -- exit now
  else  
   
   sfx_select()
   p1 = planets[p_seq]
   p2 = planets[p_seq+1]
  
   panfollow(p2.x)
   
   moving_line(p1.x,p2.x,p1.y,p2.y,animation_t%1)   
  end
  
 else
  -- then, animate the planet
  p = planets[p_seq+1]
  
  sel_strength = 2
  draw_planet_selection(p,sel_strength)
  
  fin_anim = false
  
  if (p != trgt_p) do
   if (curr_anim != nil) then
    cword = run_animation(cword,p.rule)
   else
    wait_for_anim = false
    assign_word(cword,p)
    fin_anim = true
   end
  else
   fin_anim = true
  end 
  
  
  if (anim_last_i != anim_i) do
  
   if (p != trgt_p) do
    if(p.allied != flag_allied)then
     cword = run_animation(cword,p.rule)
     wait_for_anim = true
    end
    --cword = apply_rule(cword,p.rule)
   end
  end
  
  if(p != trgt_p) then
  	draw_word(cword,false)
  end
  
 end
 
end

function panfollow(x)
  pan_dist = panat(x) - pan_x
  pan_x += dt*pan_dist*2
  pan_x = flr(pan_x/2)*2
end



function draw_alliance_status()
 
 for i=1,n_enemies_gameover do
  spr(5,2,-8+i*8)
 end

 for i=1,n_enemies do
  spr(4,2,-8+i*8)
 
 end
 
end

function _draw()

 dt = 1/30.0
 t += dt
 cls()
 --fsm =  fsm_main_menu
 if fsm == fsm_main_menu then
  draw_starfield()
  draw_main_menu()
  return
 elseif fsm == fsm_credits then
  draw_starfield()
  draw_credits()
  return
 end
 
--end
--function todo()
 
 -- stars
 draw_starfield()
 
 -- particles
 foreach(sparkles, move_sparkle)
 foreach(sparkles, draw_sparkle)
 
 if (fsm == fsm_connect) do
  -- selection input
  acted = false
  if (btnp(➡️) and sel_i<size_x-1) do
   sel_i+=1
   acted = true
   sfx_move()
  end
  if (btnp(⬅️) and sel_i>0) do
   sel_i-=1
   acted = true
   sfx_move()
  end
  if (btnp(⬆️) and sel_j>0) do
   sel_j-=1
   acted = true
   sfx_move()
  end
  if (btnp(⬇️) and sel_j<size_y-1) do
   sel_j+=1
   acted = true
   sfx_move()
  end
 end
 
 
 -- diplomacy overview
 if (fsm == fsm_connect or fsm == fsm_select) do
  for p in all(graph) do
   if (p != home_planet) do
    p.dip_bar_visible = btn(🅾️)
   end
  end
 end
  
 
 -- camera panning
 pan_spd = 5
 if (fsm == fsm_connect) do
  panfollow(get_selected().x)
 end
 if (fsm == fsm_select) do
  sel_i = trgt_p.i
  sel_j = trgt_p.j
  panfollow(trgt_p.x)
 end
  
 sel_p = get_selected()
 if (acted) do
  -- check if we already have it
  idx_found = 1
  hasit = false
  cnt = 0
  for p in all(pass_planets.list) do
   cnt+=1
   if (p.index == sel_p.index)do
    hasit = true
    idx_found = cnt
   end
  end
  
  if (hasit) do
   for i=idx_found+1,count(pass_planets.list)do
    pop(pass_planets,sel_p)
   end
  else
   push(pass_planets,sel_p)
  end
 end
 
 
 -- planets
 for p in all(graph) do
  
  drawit = true
  if (p == home_planet and fsm == fsm_gameover) do
   drawit = false
  end
  
  if (drawit) do
  
   if(p == sel_p) do
    -- selection
    sel_strength = 0
    if (fsm == fsm_select) do
     sel_strength = 1
    end
    draw_planet_selection(sel_p,sel_strength)
    
   end
  
   draw_planet(p)
   -- if necessary we also draw
   -- the diplomacy bar
   if p.dip_bar_visible and p != home_planet then
    draw_diplomacy_bar(p, 0, -flr(p.size) - 8, 15, 2)
    p.dip_bar_timer -= 1
    if p.dip_bar_timer <= 0 then
     p.dip_bar_visible = false
    end
   end
   draw_feedback(p)
  end
 end
 
 -- home
 spr(19,pan(home_planet.x-4),home_planet.y+home_planet.size+3)
 
 -- trgt
 spr(20,pan(trgt_p.x-3),trgt_p.y-3)--/+trgt_p.size+3)
 
 -- lines
 if (fsm != fsm_gameover) do
  for i = 1,count(pass_planets.list)do
   if (i < count(pass_planets.list))do
    p1 = pass_planets.list[i]
    p2 = pass_planets.list[i+1]
    
    x1 = pan(p1.x)
    x2 = pan(p2.x)
    
    fillp(0b0011001111001100.1)
    
				-- line color changes with msg type
    linecol = 11
    if (ui_selection != 2) linecol = 8
    
    line(x1,p1.y,x2,p2.y,linecol)
    fillp()
    
   end
  end
 end 
 
 if (fsm == fsm_connect) do
  -- finish the action
  if (btnp(❎)) do
 		if (get_selected() == trgt_p and get_selected() != home_planet) do
 		 send_message(pass_planets.list) 
    sfx_select()
   else
    sfx_back()
   end
  end
 end
 
 -- msg animation
 if (fsm == fsm_send) do
  animate_message(pass_planets.list)
 end
 
 -- selection state
 if (fsm == fsm_select or fsm == fsm_receive) do
	 draw_ui()
 end
 
 if (fsm == fsm_connect) do
  assign_word(cword,home_planet)
  draw_word(cword,false)
  
  assign_word(tword,trgt_p)
  draw_word(tword,true)
 end
 
 if (fsm == fsm_connect) do
  draw_timer()
 end
 
 -- alliance state
 draw_alliance_status()
 
 
 
 move_frag_sets()
 
 -- eventual char destroy
 -- animation fragments
 for frag in all(remove_anim_frags) do
  pset(frag.x, frag.y, frag.col)
 end
 
 if (fsm == fsm_gameover) do
  
  panfollow(p.x)
  
  print("∧∧ game over ∧∧",
  30-1, 60, 2)
  print("∧∧ game over ∧∧",
  30, 60, 7) 
  
  if (btnp(❎)) do
   music(0)
   reset_game()
   reset_turn()
   sfx_select()
  end
 end
 
end
__gfx__
00000000000000000000000000000000000000000000000000b00000000000000000000000000000000000000000000000000000000000000000000000000000
0000000008808800000006500aaaaaa0088888800555555000bb0000000077000000000000000000000000000000000000000000000000000000000000000000
007007008fe88880000065500a0aa0a00808808005055050bbbbb000000077007777777707777770007007000077770000077000000000000000000000000000
000770008e8888800006550009aaaa90088888800555555000bb0800000077000770077007000070007007000707707000777700000000000000000000000000
0007700088888880043450000a0000a0080000800500005000b08800000077000077770007077070077777700777777007700770000000000000000000000000
0070070008888800001300000aa00aa0080880800505505000088888000777000000000007070070077777700077770007700770000000000000000000000000
00000000008880000104000000aaaa00008888000055550000008800077777000000000000000000000000000000000000000000000000000000000000000000
00000000000800000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000
00000000000aa00000000000000cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000aa0000000000000cccc0008888800000000000aaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000
00700700000aa000000000000cc77cc087777780000000000a7777a0000000000000000000000000000000000000000000000000000000000000000000000000
00077000aaaaaaaa000aa000cc7777cc87888780000000000a7777a0000000000000000000000000000000000000000000000000000000000000000000000000
00077000aaaaaaaa000aa0000c7777c087878780000000000a7777a0000000000000000000000000000000000000000000000000000000000000000000000000
00700700000aa000000000000c7777c087888780000000000a7777a0000000000000000000000000000000000000000000000000000000000000000000000000
00000000000aa000000000000cccccc0877777800000000000aaaa00000000000000000000000000000000000000000000000000000000000000000000000000
00000000000aa0000000000000000000088888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007070000000b000077707000000000000000000000000000000000000000000008888880088888800000000000000000000000000000000000000000
0070070077000000000b0000007000000b0000000000000000000000077799900ccceee008b32180088000800000000000000000000000000000000000000000
00077000070000000bbbbb0077700000bbb00000008888008800000007079a900c0ce0e008765480080800800000000000000000000000000000000000000000
0007700007000000000b0000700000000b070707000000000007070707779a900ccceee00898ab80080080800000000000000000000000000000000000000000
007007000707070b000b000077700b07000000000000000000000000070799900c0ce0e008cdef80080008800000000000000000000000000000000000000000
00000000080000080000000008000800000000000000000000000000000000000000000008888880088888800000000000000000000000000000000000000000
00000000088888880000000008888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000040000040060000608888880000000007770000000000777007777770000000000000000000000000000000000000000000000000000000000000000
00700700004888400006006008777780008888007070777007770707007000000000000000000000000000000000000000000000000000000000000000000000
00077000008484808888660008788780008008007770007007000777007000000000000000000000000000000000000000000000000000000000000000000000
00077000008848808888660008777780008888007070007007000707000000000000000000000000000000000000000000000000000000000000000000000000
00700700008484800006006008788780008008000000007007000000707070700000000000000000000000000000000000000000000000000000000000000000
00000000004888400060000608888880000000000000007007000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000040000040000000000000000000000007070700000070707000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0c7777c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c777171c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c777771c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c771111c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c771711c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0c7111c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007700000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000770000
00000777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777770000000000777000
00000777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777770000000000777000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007700000000770000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007700000000700000
07700006cc0006cc06ccccccc06cc0000006cc0000006ccccccc00000006cc0000000006cc06ccccccc0006cc06cc0006cccccc00006cc000077000000000000
07700006cc0006cc06ccccccc06cc0000006cc0000006ccccccc00000006cc0000000006cc06ccccccc0006cc06cc0006cccccc00006cc000077000000000000
07700006cc0006cc06ccccccc06cc0000006cc0000006ccccccc00000006cc0000000006cc06ccccccc0006cc06cc0006cccccc00006cc000077000000777770
07700006cc0006cc06cc0000006cc0000006cc0000006cc00ccc00000006cc0000000006cc06cc00ccc06cccccccccc000000006cc06cc000077000000070700
07700006cc0006cc06cc0000006cc0000006cc0000006cc00ccc00000006cc0006cc0006cc06cc00ccc06cccccccccc000000006cc06cc000077000000070700
07700006cc0006cc06cc0000006cc0000006cc0000006cc00ccc00000006cc0006cc0006cc06cc00ccc06cccccccccc000000006cc06cc000077000000070700
07700006cccccccc06cccccc006cc0000006cc0000006cc00ccc00000006cc0006cc0006cc06cc00ccc0006cc06cc00000000006cc06cc000077000000700770
07700006cccccccc06cccccc006cc0000006cc0000006cc00ccc00000006cc0006cc0006cc06cc00ccc0006cc06cc00000000006cc06cc000077000000000000
07700006cccccccc06cccccc006cc0000006cc0000006cc00ccc00000006cc0006cc0006cc06cc00ccc0006cc06cc000006cccc00006cc000077000000000000
07700006cc0006cc06cc0000006cc0000006cc0000006cc00ccc00000006cc0006cc0006cc06cc00ccc0006cc06cc000006cccc00006cc000077000000000000
07700006cc0006cc06cc0000006cc0000006cc0000006cc00ccc00000006cc0006cc0006cc06cc00ccc06cccccccccc0006cccc00006cc000077000000000000
07700006cc0006cc06cc0000006cc0000006cc0000006cc00ccc00000006cc0006cc0006cc06cc00ccc06cccccccccc0006cc0000006cc000077000000000000
07700006cc0006cc06cc0000006cc0000006cc0000006cc00ccc00000000006cc0006cc00006cc00ccc06cccccccccc0006cc0000006cc000077000000000000
07700006cc0006cc06ccccccc06ccccccc06ccccccc06ccccccc00000000006cc0006cc00006ccccccc0006cc06cc00000000000000000000077000000000000
07700006cc0006cc06ccccccc06ccccccc06ccccccc06ccccccc00000000006cc0006cc00006ccccccc0006cc06cc000006cc0000006cc000077000000000000
07700006cc0006cc06ccccccc06ccccccc06ccccccc06ccccccc00000000006cc0006cc00006ccccccc0006cc06cc000006cc0000006cc000077000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007700000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007700000000000000
00000777777777777770077777777777777777777777777777777777777777777777777777777777777777777777777777777777777777770000000000000000
00000777777777777770077777777777777777777777777777777777777777777777777777777777777777777777777777777777777777770000000000000000
00000000000000000777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
00c0c1c2c3c4c5c6c7c8c9cacbcccdcecf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d0d1d2d3d4d5d6d7d8d9dadbdcdddedf000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00e0e1e2e3e4e5e6e7e8e9eaebecedeeef000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010a00001c1511f0511c1511005100000000000000000000103541c354123540d3540d3541a3541c3540000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011400001b0200d0201b0200d0201b0200d0201b0200d0201a0200f0201a0200f0201a0200f0201a0200f0201b0200a020160200a020160200a0201b0201d0201b0200a020160200a020160200a020160200a020
011400001b020070201b020070201b020070201b020070201a020090201a020090201a020090201a020090201b0200a020160200a020160200a0201b0201d0201b0200a020160200a020160200a020160200a020
011400001f5221f5221f5221f5221f5221f52221522215222452224522225222252221522215221f5221f5221b5221b5221b5221b5221f5221f52221522215221a5221a5221a5221a5221a525000001a52500000
011400001852218522185221852218522185221a5221a5221d5221d5221b5221b5221a5221a52218522185221f5221f5221f5221f5251f5221f52221522215221a5221a5221a5221a5221a5221a5220000000000
011400001b020130201b020130201b020130201b020130201a020160201a020160201a020160201a02016020160200e020160200e020160200e020160200e0200f0200a0200f0200a0200f0200a0200f0200a020
011400001b7251f725277251f725227252b725337252e7252d725297253272526725297252d72532725267252b725277252b7252e725337252e7252b725277251f7251b7251f7252272527725227251f7251b725
011400001b715187151f7151b715247151f7152771524715227151d71526715227152971526715227151d715227151f71526715227152b715267152e7152b71527715227152b715277152e7152b715337152e715
011000000f730137301a730167301a7301f7301a7301f730227302773027730277302773027730277302773000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000f730137301a730167301a7301f7301e53018130141300e1320e1320e1320e1320e1320e1320e13200500000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 01424344
01 02034344
00 02034344
00 05044344
00 05044344
00 02030644
00 02030644
00 05040744
00 05040744
00 02030644
02 02030644
00 08424344
00 09424344

