class Bove3Calculation
	attr_accessor  :scoring_notes,
						  :record_id,	:amb_ability_to_walk, :amb_walk_wo_aid, :amb_unilateral, :amb_bilateral, :amb_wheelchair,
                :pyram_strength_rightarm,
								:pyram_strength_leftarm, :pyram_strength_rightleg, :pyram_strength_leftleg, :brainstem_laughfurrow_right,
								:brainstem_laughfurrow_left, :sensory_rightarm, :sensory_leftarm, :sensory_rightleg, :sensory_leftleg,
								:brainstem_changesense_right, :brainstem_changesense_left, :vision_va_right, :vision_va_left, :brainstem_doublevision,
								:cerebellar_coord_rightarm, :cerebellar_coord_leftarm, :cerebellar_coord_rightleg, :cerebellar_coord_leftleg,
								:brainstem_speakclear, :cerebellar_balance, :pyram_spastic_rightarm, :pyram_spastic_leftarm, :pyram_spastic_rightleg,
								:pyram_spastic_leftleg, :cerebral_concentration_memory, :brainstem_swallow, :bowel, :bladder_urgency,
								:bladder_hesitancy, :cerebellar_vertigo, :brainstem_hearing, :cerebral_fatigue, :cerebral_interest_pleasure,
								:cerebral_hopeless_depressed,:patient_reported_edss_v3_complete,

                :functional_overall,
									:calc_sum_func_scores,:calc_edss,:calc_ai,:calc_nrs,:calc_mds,:calc_pyramidal,:calc_cerebellar,
								:calc_brainstem,:calc_sensory,:calc_bowelbladder,:calc_vision,:calc_cerebral,:calc_fother, :calc_depression,
								:calc_fs2,:calc_fs3,:calc_fs4,:calc_fs5

=begin
	PREDSS Algorithm in brief:
			Determine SFS:
				Calc F1		# kurtzke pyramidal
				Calc F2		# kurtzke cerebellar
				Calc F3		# kurtzke brainstem
				Calc SBS
				Calc F4		# kurtzke sensory
				Calc F5		# kurtzke bowel/bladder
				Calc F6		# kurtzke	vision
				Calc F7		# kurtzke cerebral/mental
				Calc F8		# kurtzke other?
				Calc FS scores
			Then:
				Calc EDSS
				Calc AI
				Calc NF1
				Calc NF2
				Calc NF3
				Calc NF4
				Calc NF5
				Calc NF6
				Calc NF7
				Calc NF8
				Calc NF9
				Calc summary statistics


		Algorithm:
			SFS
				f1f <- f1fl, f1fr
				f1u = f1a + f1b
				f1l = f1c + f1d
				f2u = f2a + f2b
				f2l = f2c + f2d
				f1h = (f1a + f1c - f1b - f1d ) / 2
				f2h = (f2a + f2c - f2b - f2d ) / 2
				f4f <- f14r, f4fr, f4fl  ### f14r  DOES NOT EXIST!!!!!!!!!!!!!!!!!!!!!!
				f4u = f4a + f4d
				f4l = f4c + f4d
				f4h = (f4a + f4c - f4b - f4d ) / 2
				f5t = max(f5ta, f5tb)
				f6t = f6a + f6b
				f8u = f8a + f8b
				f8l = f8c + f8d
				f8h = (f8a + f8c - f8b - f8d ) / 2

				tf1l <- f1l, walk_overall
				tf1u <- f1u, fs
				f1 <- tf1l, tf1u, f1h

				tf2l <- f2l, walk_overall, tf1l, f1h
				tf2u <- f2u, tf1u, fs
				f2 <- tf2l, tf2u, f2h

				f3 <- f2s, f1f, f4f, b1, b2, b3, b4

				tf4l <- f4l, walk_overall
				tf4u <- fs, f4u
				f4 <- tf4l, tf4u, f4h

				f5 <- f5t

				f6 <- f6t

				f7 <- f7t, c1

				tf8l <- f8l, walk_overall
				tf8u <- f8l, walk_overall, fs, f8u
				f8 <- tf8l, tf8u, f8h

				sfs = f1+f2+f3+f4+f5+f6+f7+f8

=end

	def initialize(record)
		self.scoring_notes = {}
		# integerize redcap record values and assign to model attributes
		self.functional_overall = -9
		self.record_id = record["record_id"].to_i
		self.patient_reported_edss_v3_complete = record["patient_reported_edss_v3_complete"].to_i
		self.amb_ability_to_walk = record["amb_ability_to_walk"].to_i
		self.amb_walk_wo_aid = record["amb_walk_wo_aid"].to_i
		self.amb_unilateral = record["amb_unilateral"].to_i
		self.amb_bilateral = record["amb_bilateral"].to_i
		self.amb_wheelchair = record["amb_wheelchair"].to_i
		self.pyram_strength_rightarm = record["pyram_strength_rightarm"].to_i
		self.pyram_strength_leftarm = record["pyram_strength_leftarm"].to_i
		self.pyram_strength_rightleg = record["pyram_strength_rightleg"].to_i
		self.pyram_strength_leftleg = record["pyram_strength_leftleg"].to_i
		self.brainstem_laughfurrow_right = record["brainstem_laughfurrow_right"].to_i
		self.brainstem_laughfurrow_left = record["brainstem_laughfurrow_left"].to_i
		self.sensory_rightarm = record["sensory_rightarm"].to_i
		self.sensory_leftarm = record["sensory_leftarm"].to_i
		self.sensory_rightleg = record["sensory_rightleg"].to_i
		self.sensory_leftleg = record["sensory_leftleg"].to_i
		self.brainstem_changesense_right = record["brainstem_changesense_right"].to_i
		self.brainstem_changesense_left = record["brainstem_changesense_left"].to_i
		self.vision_va_right = record["vision_va_right"].to_i
		self.vision_va_left = record["vision_va_left"].to_i
		self.brainstem_doublevision = record["brainstem_doublevision"].to_i
		self.cerebellar_coord_rightarm = record["cerebellar_coord_rightarm"].to_i
		self.cerebellar_coord_leftarm = record["cerebellar_coord_leftarm"].to_i
		self.cerebellar_coord_rightleg = record["cerebellar_coord_rightleg"].to_i
		self.cerebellar_coord_leftleg = record["cerebellar_coord_leftleg"].to_i
		self.brainstem_speakclear = record["brainstem_speakclear"].to_i
		self.cerebellar_balance = record["cerebellar_balance"].to_i
		self.pyram_spastic_rightarm = record["pyram_spastic_rightarm"].to_i
		self.pyram_spastic_leftarm = record["pyram_spastic_leftarm"].to_i
		self.pyram_spastic_rightleg = record["pyram_spastic_rightleg"].to_i
		self.pyram_spastic_leftleg = record["pyram_spastic_leftleg"].to_i
		self.cerebral_concentration_memory = record["cerebral_concentration_memory"].to_i
		self.brainstem_swallow = record["brainstem_swallow"].to_i
		self.bowel = record["bowel"].to_i
		self.bladder_urgency = record["bladder_urgency"].to_i
		self.bladder_hesitancy = record["bladder_hesitancy"].to_i
		self.cerebellar_vertigo = record["cerebellar_vertigo"].to_i
		self.brainstem_hearing = record["brainstem_hearing"].to_i
		self.cerebral_fatigue = record["cerebral_fatigue"].to_i
		self.cerebral_interest_pleasure = record["cerebral_interest_pleasure"].to_i
		self.cerebral_hopeless_depressed = record["cerebral_hopeless_depressed"].to_i

		# initialize calculated/derived values to nil
		self.calc_sum_func_scores = self.calc_edss = self.calc_ai = self.calc_mds = self.calc_nrs = self.calc_pyramidal = self.calc_cerebellar = self.calc_brainstem =
				self.calc_sensory = self.calc_bowelbladder = self.calc_vision = self.calc_cerebral = self.calc_fother = self.calc_fs2 = self.calc_fs3 = self.calc_fs4 = self.calc_fs5 = :nil
	end

	def calculate_sys_functional_scores
		# 1 pyramidal
		strength_side = ((self.pyram_strength_rightarm + self.pyram_strength_rightleg) - (self.pyram_strength_leftarm + self.pyram_strength_leftleg)).abs / 2.0
		pyramidal_lower = self.calculate_pyramidal_lower(self.pyram_strength_rightleg + self.pyram_strength_leftleg, self.amb_ability_to_walk)
		pyramidal_upper = self.calculate_pyramidal_upper(self.pyram_strength_rightarm + self.pyram_strength_leftarm, self.functional_overall)
		self.calc_pyramidal = self.calculate_pyramidal(pyramidal_lower, pyramidal_upper, strength_side)
		# 2 cerebellar
		cerebellar_side = ((self.cerebellar_coord_rightarm + self.cerebellar_coord_rightleg) - (self.cerebellar_coord_leftarm + self.cerebellar_coord_leftleg)).abs / 2.0
		total_coord_lower = self.calculate_cerebellar_lower(self.cerebellar_coord_rightleg + self.cerebellar_coord_leftleg, self.amb_ability_to_walk, pyramidal_lower)
		total_coord_upper = self.calculate_cerebellar_upper(self.cerebellar_coord_rightarm + self.cerebellar_coord_leftarm, pyramidal_upper, self.functional_overall)
		self.calc_cerebellar = self.calculate_cerebellar(total_coord_lower, total_coord_upper, cerebellar_side)
		# 3 brainstem
		self.calc_brainstem = self.calculate_brainstem(self.brainstem_speakclear,
																 self.merge_left_right(self.brainstem_laughfurrow_right,self.brainstem_laughfurrow_left),
																 self.merge_left_right(self.brainstem_changesense_right,self.brainstem_changesense_left),
																 self.brainstem_doublevision, self.brainstem_swallow, self.cerebellar_vertigo, self.brainstem_hearing)
		# 4 sensory
		sensory_side = ((self.sensory_rightarm + self.sensory_rightleg) - (self.sensory_leftarm + self.sensory_leftleg)).abs / 2.0
		total_sensory_lower = self.calculate_sensory_lower(self.sensory_rightleg + self.sensory_leftleg, self.amb_ability_to_walk)
		total_sensory_upper = self.calculate_sensory_upper(self.functional_overall, self.sensory_rightarm + self.sensory_leftarm)
		self.calc_sensory = self.calculate_sensory(total_sensory_lower, total_sensory_upper, sensory_side)


		# 5 bowel/bladder
		self.calc_bowelbladder = self.calculate_bowelbladder(self.bowel, self.bladder_urgency, self.bladder_hesitancy )

		# 6 vision
		self.calc_vision = self.calculate_vision(self.vision_va_right, self.vision_va_left)

		# 7 cerebral
		self.calc_cerebral = self.calculate_cerebral(self.cerebral_concentration_memory, self.cerebral_fatigue)

		# 8 other
		fother_lower = self.pyram_spastic_rightleg + self.pyram_spastic_leftleg
		fother_upper = self.pyram_spastic_rightarm + self.pyram_spastic_leftarm
		fother_side = ((self.pyram_spastic_rightarm + self.pyram_spastic_rightleg) - (self.pyram_spastic_leftarm + self.pyram_spastic_leftleg)).abs / 2.0
		total_fother_lower = self.calculate_total_fother_lower(fother_lower, self.amb_ability_to_walk)
		total_fother_upper = self.calculate_total_fother_upper(fother_lower, self.amb_ability_to_walk, self.functional_overall, fother_upper)
		self.calc_fother = self.calculate_fother(total_fother_lower, total_fother_upper, fother_side)

		# sum FS scores
		self.calc_sum_func_scores = self.calc_pyramidal + self.calc_cerebellar + self.calc_brainstem + self.calc_sensory + self.calc_bowelbladder + self.calc_vision + self.calc_cerebral + self.calc_fother

		# depression
		self.calc_depression = self.cerebral_interest_pleasure + self.cerebral_hopeless_depressed
	end

	#### START SFS SUB-FUNCTIONS ####

	def merge_left_right(left,right)
		result= :nil
		if (right+left)==0
			result=0
		end
		if (right+left)<=2
			result=1
		end
		if (right+left)<=4
			result=2
		end
		if right==3 || left==3
			result=3
		end
		return result
	end

	def calculate_pyramidal_upper(strength_upper,functional_overall)
		tf1u=0
		if strength_upper==1 || strength_upper==2
			tf1u=1
		elsif strength_upper==3
			tf1u=2
		elsif strength_upper==4
			tf1u=3
		elsif strength_upper>4
			tf1u=4
		end

		if strength_upper>4 && functional_overall<=2
			tf1u=3
		end

		return tf1u
	end

	def calculate_pyramidal_lower(strength_lower, walk_overall)
		tf1l=0
		if strength_lower==1 || strength_lower==2
			tf1l=1
		elsif strength_lower==3
			tf1l=2
		elsif strength_lower==4
			tf1l=3
		elsif strength_lower>4
			tf1l=4
		end

		if strength_lower>=3 && walk_overall<=2
			tf1l=1
		elsif strength_lower>=3 && walk_overall==3
			tf1l=2
		elsif strength_lower>=5 && walk_overall==4
			tf1l=3
		end

		return tf1l
	end

	def calculate_pyramidal(pyram_lower, pyram_upper, pyram_side)
		f1 = [pyram_upper,pyram_lower].max

		if f1<2 && pyram_side==2
			f1=2
		elsif f1<3 && pyram_side==2.5
			f1=3
		elsif f1<3 && (pyram_upper+pyram_lower)>=4 && (pyram_upper+pyram_lower)<=5
			f1=3
		elsif pyram_side==3
			f1=4
		elsif (pyram_upper+pyram_lower)>=6 && (pyram_upper+pyram_lower)<=7
			f1=4
		elsif (pyram_upper+pyram_lower)==8
			f1=5
		end
		return f1
	end

	def calculate_cerebellar_upper(cerebellar_upper, pyram_upper, functional_overall)
		tf2u=0
		if cerebellar_upper==1 || cerebellar_upper==2
			tf2u=1
		elsif cerebellar_upper==3
			tf2u=2
		elsif cerebellar_upper==4
			tf2u=3
		elsif cerebellar_upper>4
			tf2u=4
		end

		if cerebellar_upper>4 && functional_overall <=2
			tf2u=3
		end

		if pyram_upper>=3 && tf2u>=3
			tf2u-=1
		end

		return tf2u
	end

	def calculate_cerebellar_lower(cerebellar_lower, ambulation_overall, pyram_lower)
		tf2l=0
		if cerebellar_lower==1 || cerebellar_lower==2
			tf2l=1
		elsif cerebellar_lower==3
			tf2l=2
		elsif cerebellar_lower==4
			tf2l=3
		elsif cerebellar_lower>4
			tf2l=4
		end

		if cerebellar_lower>=3 && ambulation_overall<=2
			tf2l=1
		elsif cerebellar_lower>=3 && ambulation_overall==3
			tf2l=2
		elsif cerebellar_lower>=5 && ambulation_overall==4
			tf2l=3
		end

		if pyram_lower>=3 && tf2l>=3
			tf2l-=1
		end

		return tf2l
	end

	def calculate_cerebellar(cerebellar_lower,cerebellar_upper,cerebellar_side)
		if cerebellar_lower>=cerebellar_upper
			f2=cerebellar_lower
		else
			f2=cerebellar_upper
		end

		if f2<2 && cerebellar_side==2
			f2=2
		elsif f2<3 && cerebellar_side==2.5
			f2=3
		end

		if f2<3 && (cerebellar_upper+cerebellar_lower)>=4 && (cerebellar_upper+cerebellar_lower)<=5
			f2=3
		end

		if cerebellar_side==3
			f2=4
		end

		if (cerebellar_upper+cerebellar_lower)>=6 && (cerebellar_upper+cerebellar_lower)<=7
			f2=4
		end

		if (cerebellar_upper+cerebellar_lower)==8
			f2=5
		end

		unless defined? f2 then
			self.scoring_notes[:cerebellar] = 'Failed'
			f2=-9
		end
		return f2

	end

	def calculate_brainstem(speaking,face_strength,face_sensory,double_vision,swallowing,vertigo,hearing)
		sbs = speaking + face_strength + face_sensory + double_vision + swallowing + vertigo
		if sbs==0
			f3=0
		end
		if sbs>0 || hearing>1
			f3=1
		end
		if face_sensory==3 || vertigo==3 || speaking==2 || face_strength==2 || double_vision==2 || swallowing==2
			f3=2
		end
		if speaking==3 || face_strength==3
			f3=4
		end
		if double_vision==3 && f3<4
			f3=3
		end
		if f3==4 && swallowing==3
			f3=5
		end
		if sbs<=5 && f3<=2
			f3=1
		end
		if sbs>=6 && f3<=2
			f3=2
		end

		unless defined? f3 then
			self.scoring_notes[:brainstem] = "Failed"
			f3 = -9
		end

		return f3
	end

	def calculate_sensory_upper(functional_overall, sensory_upper)
		tf4u=0
		if sensory_upper==1 || sensory_upper==2
			tf4u=1
		elsif sensory_upper==3
			tf4u=2
		elsif sensory_upper==4
			tf4u=3
		elsif sensory_upper>=5
			tf4u=4
		end

		if sensory_upper>4 && functional_overall<=2
			tf4u=3
		end
		return tf4u
	end

	def calculate_sensory_lower(sensory_lower, ambulation_overall)
		tf4l=0
		if sensory_lower==1 || sensory_lower==2
			tf4l=1
		elsif sensory_lower==3
			tf4l=2
		elsif sensory_lower==4
			tf4l=3
		elsif sensory_lower>=5
			tf4l=4
		end

		if sensory_lower>4 && ambulation_overall<=2
			tf4l=tf4l-1
		end
		return tf4l
	end

	def calculate_sensory(sensory_lower, sensory_upper, sensory_side)
		if sensory_lower>=sensory_upper
			f4=sensory_lower
		else
			f4=sensory_upper
		end

		if f4<2 && sensory_side==2
			f4=2
		end

		if f4<3 && (sensory_upper+sensory_lower)>=4 && (sensory_upper+sensory_lower)<=5
			f4=3
		end

		if f4<3 && sensory_side==2.5
			f4=3
		end

		if sensory_side==3
			f4=4
		end

		if (sensory_upper+sensory_lower)>=6 && (sensory_upper+sensory_lower)<=7
			f4=4
		elsif (sensory_upper+sensory_lower)==8
			f4=5
		end

		if f4.nil?
			self.scoring_notes[:sensory] = 'Failed'
			f4=-9
		end
		return f4
	end

  def calculate_bowelbladder(bowel,blad_urgency, blad_hesitancy)
		if bowel==4 && blad_urgency==4 && blad_hesitancy==5
			return 5
		end
		if (bowel==4 && blad_urgency<=3 && blad_hesitancy<=4) ||
				(bowel<=4 && blad_urgency==4 && blad_hesitancy<=4) ||
				(bowel<=3 && blad_urgency<=3 && blad_hesitancy>=4)
			return 4
		end
		if (bowel==3 && [blad_urgency,blad_hesitancy].max<=2) ||
			(bowel<=1 && blad_urgency==3 && blad_hesitancy<=3) ||
			(bowel<=3 && blad_urgency<=3 && blad_hesitancy==3) ||
			(bowel<=3 && blad_urgency<=3 && blad_hesitancy==4)
			return 3
		end
    if [bowel,blad_urgency,blad_hesitancy].max==2
      return 2
    end
		if [bowel,blad_urgency,blad_hesitancy].max==1
			return 1
		end
		if [bowel,blad_urgency,blad_hesitancy].max==0
			return 0
		end

		self.scoring_notes['bowel_bladder'] = 'No match'
		return -9

	end

	def calculate_vision(right, left)
		# Note: bumping ranges from 0-3 to 1-4 to match scoring design per P.I.
		right = right + 1
		left = left + 1

		if [right,left].max==4 && [right,left].min==3 then
			return 4
		end
		if [right,left].max==4 && (1..2).include?([right,left].min) then
			return 3
		end
		if [right,left].max==3 && (1..3).include?([right,left].min) then
			return 2
		end
		if [right,left].max==2 && (1..2).include?([right,left].min) then
			return 1
		end
		if [right,left].uniq==[1] then
			return 0
		end
		self.scoring_notes[:vision] = "Failed: #{right},#{left} not scorable."
		return -9
	end

	def calculate_cerebral(cog_conc_mem, fatigue)
		# note: fatigue response options are 0-3 instead of 1-4
		if cog_conc_mem==5 then
			return 5
		end
		if cog_conc_mem==4 then
			return 4
		end
		if cog_conc_mem==3 then
			return 3
		end
		if cog_conc_mem==2 || (cog_conc_mem==1 && fatigue>=2) then
			return 2
		end
		if cog_conc_mem==1 && fatigue==1 then
			return 1
		end
		if cog_conc_mem==1 && fatigue==0 then
			return 0
		end
		self.scoring_notes['cerebral'] = 'Failed'
		return -9
	end

	def calculate_total_fother_upper(spasm_lower, ambulation_overall, functional_overall, spasm_upper)
		tf8u=0
		if spasm_upper==1 || spasm_upper==2
			tf8u=1
		elsif spasm_upper>=3 && spasm_upper<=4
			tf8u=2
		end

		if spasm_lower>=4 && ambulation_overall<=2 && tf8u>=2
			tf8u=tf8u-1
		end

		if spasm_upper>4 && functional_overall<=2
			tf8u=2
		end

		if spasm_upper>4
			tf8u=3
		end
		return tf8u
	end

	def calculate_total_fother_lower(spasm_lower, ambulation_overall)
		tf8l=0
		if spasm_lower==1 || spasm_lower==2
			tf8l=1
		elsif spasm_lower>=3 && spasm_lower<=4
			tf8l=2
		end

		if spasm_lower>=3 && ambulation_overall>=3 && ambulation_overall<=4
			tf8l=2
		end

		if spasm_lower>=3 && ambulation_overall<=2
			tf8l=1
		end

		if spasm_lower>4
			tf8l=3
		end
		return tf8l
	end

	def calculate_fother(spasm_lower, spasm_upper, spasm_side)
		if spasm_lower>=spasm_upper
			f8=spasm_lower
		else
			f8=spasm_upper
		end
		if f8<2 && spasm_side==2
			f8=2
		end
		if (spasm_upper+spasm_lower)>=4
			f8=3
		end
		if spasm_side>2
			f8=3
		end
		if f8.nil? then
			self.scoring_notes[:fother] = "Failed"
			f8=-9
		end


		return f8
	end

	#### END SFS SUB-FUNCTIONS ####

	def calculate_fs_nums
		# for each SFS score, increment these fs scores by a certain amount
		# these 4 fs scores are intermediate scores derived from accumulation of the 8 functional system scores
		fs2 = fs3 = fs4 = fs5 = 0

		[self.calc_pyramidal, self.calc_cerebellar, self.calc_brainstem, self.calc_sensory, self.calc_bowelbladder,
		 self.calc_vision, self.calc_cerebral, self.calc_fother].each do |score|
			if score == 2
				fs2 = fs2+1
			elsif score == 3
				fs3 = fs3+1
			elsif score == 4
				fs4 = fs4+1
			elsif score > 4
				fs5 = fs5+1
			end
		end
		self.calc_fs2 = fs2
		self.calc_fs3 = fs3
		self.calc_fs4 = fs4
		self.calc_fs5 = fs5
	end

	def calculate_edss
		if self.amb_ability_to_walk >= 9 || (3..5).include?(self.amb_ability_to_walk)
      # need functional_overall to score!
			self.scoring_notes[:edss] = "Requires functional overall"
			self.calc_edss = -9
			return
		end

    # make array of FS scores for doing punch card counts at low EDSSs
    fs = [self.calc_pyramidal,self.calc_cerebellar,self.calc_brainstem,self.calc_sensory,self.calc_bowelbladder,self.calc_vision,self.calc_cerebral,self.calc_fother]

		# Amb=9-10. use functional_overall and sum of SF scores
		if self.amb_ability_to_walk==10 && self.functional_overall==5 && self.calc_sum_func_scores>=30
			self.scoring_notes[:edss_category] = '10 | . | 5 | 30-40'
			self.calc_edss=9.5
			return
		elsif self.amb_ability_to_walk==10 && self.functional_overall==5 && (20..29).include?(self.calc_sum_func_scores)
			self.scoring_notes[:edss_category] = '10 | . | 5 | 20-29'
			self.calc_edss=9
			return
		elsif self.amb_ability_to_walk==10 && self.functional_overall==5 && self.calc_sum_func_scores<20
			self.scoring_notes[:edss_category] = '10 | . | 5 | <20'
			self.calc_edss=8.5
			return
		elsif self.amb_ability_to_walk==10 && (0..5).include?(functional_overall)
			self.scoring_notes[:edss_category] = '10 | . | <5 | .'
			self.calc_edss=8
			return
		elsif self.amb_ability_to_walk==9 && self.functional_overall==5 && self.calc_sum_func_scores>15
			self.scoring_notes[:edss_category] = '9 | . | 5 | >15'
			self.calc_edss=8
			return
		elsif self.amb_ability_to_walk==9 && self.functional_overall==4 && self.calc_sum_func_scores>=20
			self.scoring_notes[:edss_category] = '9 | . | 4 | >=20'
			self.calc_edss=8
			return
		elsif self.amb_ability_to_walk==9 && self.functional_overall==5 && self.calc_sum_func_scores<=15
			self.scoring_notes[:edss_category] = '9 | . | 5 | <=15'
			self.calc_edss=7.5
			return
		elsif self.amb_ability_to_walk==9 && self.functional_overall==4 && self.calc_sum_func_scores<20
			self.scoring_notes[:edss_category] = '9 | . | 4 | <20'
			self.calc_edss=7.5
			return
		elsif self.amb_ability_to_walk==9 && (0..3).include?(functional_overall)
			self.scoring_notes[:edss_category] = '9 | . | <4 | .'
			self.calc_edss=7
			return
		elsif self.amb_ability_to_walk==9 && (0..3).include?(functional_overall)
			self.scoring_notes[:edss_category] = '9 | . | <4 | .'
			self.calc_edss=7
			return
		elsif self.amb_ability_to_walk==8 && self.amb_wheelchair>=40 && self.amb_bilateral>=10 then
			self.scoring_notes[:edss_category] = '8 | wh>=40 bl>=10 | . | .'
			self.calc_edss=7
			return
		elsif self.amb_ability_to_walk==7 && self.amb_wheelchair>=40 && self.amb_bilateral>=20 then
			self.scoring_notes[:edss_category] = '7 | wh>=40 bl>=20 | . | .'
			self.calc_edss=7
			return
		elsif self.amb_ability_to_walk==8 && self.amb_wheelchair>=40 && self.amb_bilateral<10 then
			self.scoring_notes[:edss_category] = '8 | wh>=40 bl<10 | . | .'
			self.calc_edss=6.5
			return
		elsif self.amb_ability_to_walk==7 && self.amb_wheelchair>=40 && self.amb_bilateral<20 then
			self.scoring_notes[:edss_category] = '7 | wh>=40 bl<20 | . | .'
			self.calc_edss=6.5
			return
		elsif (7..8).include?(self.amb_ability_to_walk) && self.amb_wheelchair<40 && self.amb_bilateral<20 then
			self.scoring_notes[:edss_category] = '7-8 | wh<40 bl<20 | . | .'
			self.calc_edss=6.5
			return
		elsif self.amb_ability_to_walk==6 && (self.amb_wheelchair + self.amb_bilateral)>50
			self.scoring_notes[:edss_category] = '6 | wh+bl>50 | . | .'
			self.calc_edss=6.5
			return
		elsif (7..8).include?(self.amb_ability_to_walk) && (self.amb_wheelchair + self.amb_bilateral)<=20 && self.amb_unilateral>=20 then
			self.scoring_notes[:edss_category] = '7-8 | wh+bl<=20 u>=20| . | .'
			self.calc_edss=6
			return
		elsif self.amb_ability_to_walk==6 && self.amb_walk_wo_aid<60 && (self.amb_wheelchair + self.amb_bilateral)<50
			self.scoring_notes[:edss_category] = '6 | wo<60 wh+bl<50 | . | .'
			self.calc_edss=6
			return
    end

    # Check for some cases where amb is [2..6] and functional_overall might matter
		if self.amb_ability_to_walk==6 && (60..80).include?(self.amb_walk_wo_aid)
        #&& functional_overall>=3
			  #self.scoring_notes[:edss_category] = '6 | wo60-80 | >=3 | .'
			  #self.calc_edss=6
        self.scoring_notes[:edss] = 'Requires functional_overall'
        self.calc_edss='n/a'
			  return
		elsif (7..8).include?(self.amb_ability_to_walk)  && self.amb_unilateral<20 && (self.amb_wheelchair + self.amb_bilateral)<20
			self.scoring_notes[:edss_category] = '7-8 | ul<20 wh+bl<20 | . | .'
			self.calc_edss=5.5
			return
    elsif self.amb_ability_to_walk==6 && (60..80).include?(self.amb_walk_wo_aid)
      #&& (0..2).include?(self.functional_overall)
			#self.scoring_notes[:edss_category] = '6 | wo60-80 | <3 | .'
			#self.calc_edss=5.5
      self.scoring_notes[:edss] = 'Requires functional_overall'
      self.calc_edss='n/a'
			return
    elsif self.amb_ability_to_walk==6 && self.amb_walk_wo_aid>80
      #&& self.functional_overall>=3
			#self.scoring_notes[:edss_category] = '6 | wo >80 | >=3 | .'
			#self.calc_edss=5.5
      self.scoring_notes[:edss] = 'Requires functional_overall'
      self.calc_edss='n/a'
      return
    elsif (4..5).include?(self.amb_ability_to_walk)
      #&& self.functional_overall>=3
			#self.scoring_notes[:edss_category] = '4-5 | . | >=3 | .'
			#self.calc_edss=5.5
      self.scoring_notes[:edss] = 'Requires functional_overall'
      self.calc_edss='n/a'
      return
    elsif self.amb_ability_to_walk==6 && self.amb_walk_wo_aid>80
      #&& (0..2).include?(self.functional_overall)
			#self.scoring_notes[:edss_category] = '6 | wo >80 | <=2 | .'
			#self.calc_edss=5
      self.scoring_notes[:edss] = 'Requires functional_overall'
      self.calc_edss='n/a'
			return
    elsif (4..5).include?(self.amb_ability_to_walk)
      #&& self.functional_overall==2
			#self.scoring_notes[:edss_category] = '4-5 | . | 2 | .'
			#self.calc_edss=5
      self.scoring_notes[:edss] = 'Requires functional_overall'
      self.calc_edss='n/a'
			return
    elsif (2..3).include?(self.amb_ability_to_walk)
      #&& self.functional_overall>=3
			#self.scoring_notes[:edss_category] = '2-3 | . | >=3 | .'
			#self.calc_edss=5
      self.scoring_notes[:edss] = 'Requires functional_overall'
      self.calc_edss='n/a'
			return
    elsif (4..5).include?(self.amb_ability_to_walk)
      #&& self.functional_overall==1
			#self.scoring_notes[:edss_category] = '4-5 | . | 1 | .'
			#self.calc_edss=4.5
      self.scoring_notes[:edss] = 'Requires functional_overall'
      self.calc_edss='n/a'
			return
    elsif self.amb_ability_to_walk==3
      #&& (0..2).include?(self.functional_overall)
			#self.scoring_notes[:edss_category] = '3 | . | <=2 | .'
			#self.calc_edss=4.5
      self.scoring_notes[:edss] = 'Requires functional_overall'
      self.calc_edss='n/a'
			return
    elsif fs.count(4)==1 && fs.max==4
      self.scoring_notes[:edss_category] = '. | . | . | 1f4'
      self.calc_edss=3.5
      return
    elsif fs.count(2)==5 && fs.max==2
      self.scoring_notes[:edss_category] = '. | . | . | 5f2'
      self.calc_edss=3.5
      return
    elsif fs.count(3)==2 && fs.max==2
      self.scoring_notes[:edss_category] = '. | . | . | 2f3'
      self.calc_edss=3.5
      return
    elsif fs.count(3)==1 && (2..3).include?(fs.count(2)) && fs.max==3
      self.scoring_notes[:edss_category] = '. | . | . | 1f3 + 2-3f2'
      self.calc_edss=3.5
      return
    elsif (3..4).include?(fs.count(2)) && fs.max==2
      self.scoring_notes[:edss_category] = '. | . | . | 3-4f2'
      self.calc_edss=3
      return
    elsif fs.count(3)==1 && (0..1).include?(fs.count(2)) && fs.max==3
      self.scoring_notes[:edss_category] = '. | . | . | 1f3 + 0-1f2'
      self.calc_edss=3
      return
    elsif fs.count(2)==2 && fs.max==2
      self.scoring_notes[:edss_category] = '. | . | . | 2f2'
      self.calc_edss=2.5
      return
    elsif fs.count(2)==1 && fs.max==2
      self.scoring_notes[:edss_category] = '. | . | . | 1f2'
      self.calc_edss=2
      return
    elsif fs.count(1)>=3 && fs.max==1
      self.scoring_notes[:edss_category] = '. | . | . | 3f1'
      self.calc_edss=2
      return
    elsif fs.count(1)==2 && fs.max==1
      self.scoring_notes[:edss_category] = '. | . | . | 2f1'
      self.calc_edss=1.5
      return
    elsif fs.count(1)==1 && fs.max==1
      self.scoring_notes[:edss_category] = '. | . | . | 1f1'
      self.calc_edss=1
      return
    elsif fs.uniq==[0]
      self.scoring_notes[:edss_category] = '. | . | . | 5x0'
      self.calc_edss=0
      return
    end

    self.scoring_notes[:edss_category] = 'default 4'
    self.calc_edss='!4?'

	end


	#### END EDSS FUNCTIONS ####


	def calculate_AI
		# Start AI at zero, modify using survey responses
		aI = 0
		if self.amb_ability_to_walk==1
			aI=0
		elsif self.amb_ability_to_walk==2
			aI=1
		elsif self.amb_ability_to_walk>=3 && self.amb_ability_to_walk<=4
			aI=2
		elsif self.amb_ability_to_walk==5 && self.amb_walk_wo_aid>=20 && (self.amb_bilateral+self.amb_wheelchair)<=10
			aI=3
		elsif self.amb_ability_to_walk==5 && self.amb_walk_wo_aid>=20 && (self.amb_bilateral+self.amb_wheelchair)>=10
			aI=4
		elsif self.amb_ability_to_walk==5 && self.amb_walk_wo_aid<20
			aI=4
		elsif self.amb_ability_to_walk==6 && (self.amb_bilateral+self.amb_wheelchair)<50 && self.amb_wheelchair<=20
			aI=4
		elsif self.amb_ability_to_walk==6 && (self.amb_bilateral+self.amb_wheelchair)>=50 && self.amb_wheelchair<=20
			aI=5
		elsif self.amb_ability_to_walk==6 && self.amb_wheelchair>20
			aI=6
		end

		if self.amb_ability_to_walk==6 && (self.amb_walk_wo_aid+self.amb_unilateral)>=80
			aI=4
		end

		if self.amb_ability_to_walk==6 && self.amb_walk_wo_aid>=80
			aI=3
		elsif self.amb_ability_to_walk>=7 && self.amb_ability_to_walk<=8 && (self.amb_bilateral+self.amb_wheelchair)<50 && self.amb_wheelchair<=20
			aI=5
		elsif self.amb_ability_to_walk>=7 && self.amb_ability_to_walk<=8 && (self.amb_bilateral+self.amb_wheelchair)<50 && self.amb_wheelchair>20
			aI=6
		elsif self.amb_ability_to_walk>=7 && self.amb_ability_to_walk<=8 && (self.amb_bilateral+self.amb_wheelchair)>=50 && self.amb_wheelchair<=20
			aI=6
		elsif self.amb_ability_to_walk>=7 && self.amb_ability_to_walk<=8 && (self.amb_bilateral+self.amb_wheelchair)>=50 && self.amb_wheelchair>20
			aI=7
		end

		if self.amb_ability_to_walk>=7 && self.amb_ability_to_walk<=8 && (self.amb_walk_wo_aid+self.amb_unilateral)>=80
			aI=4
		end

		if self.amb_ability_to_walk>=7 && self.amb_ability_to_walk<=8 && self.amb_walk_wo_aid>=80
			aI=3
		end

		if self.amb_ability_to_walk==9 && self.functional_overall<=2
			aI=7
		elsif self.amb_ability_to_walk==9 && self.functional_overall>2
			aI=8
		end

		if self.amb_ability_to_walk==10 && self.functional_overall<=4
			aI=8
		elsif self.amb_ability_to_walk==10 && self.functional_overall==5
			aI=9
		end

		self.calc_ai = aI

	end


	#################################################################
	#################################################################
	#################################################################
	#################################################################
	#################################################################
	###########  BELOW HERE TBD ##############
	#################################################################
	#################################################################

	def calculate_NRS


		f1u = self.pyram_strength_rightarm + self.pyram_strength_leftarm
		f1l = self.pyram_strength_rightleg + self.pyram_strength_leftleg
		f2l = self.cerebellar_coord_rightleg + self.cerebellar_coord_leftleg
		f2u = self.cerebellar_coord_rightarm + self.cerebellar_coord_leftarm
		f1h = ((self.pyram_strength_rightarm + self.pyram_strength_rightleg) - (self.pyram_strength_leftarm + self.pyram_strength_leftleg)).abs / 2.0
		f2h = ((self.cerebellar_coord_rightarm + self.cerebellar_coord_rightleg) - (self.cerebellar_coord_leftarm + self.cerebellar_coord_leftleg)).abs / 2.0

		f4u = self.sensory_rightarm + self.sensory_leftarm
		f4l = self.sensory_rightleg + self.sensory_leftleg

		f5t = [self.bowel, self.bladder].max
		f8l = self.pyram_spastic_rightleg + self.pyram_spastic_leftleg
		f8u = self.pyram_spastic_rightarm + self.pyram_spastic_leftarm
		f8h = ((self.pyram_spastic_rightarm + self.pyram_spastic_rightleg) - (self.pyram_spastic_leftarm + self.pyram_spastic_leftleg)).abs / 2.0

		nf1l = calc_nf1l(f1l, self.amb_ability_to_walk)
		nf1u = calc_nf1u(f1u, self.functional_overall)
		nf1 = calc_nf1(nf1u, nf1l, f1h)

		nf2l = calc_nf2l(f2l, self.amb_ability_to_walk)
		nf2u = calc_nf2u(self.functional_overall, f2u)
		nf2 = calc_nf2(nf2u, nf2l, f2h)

		nf3 = calc_nf3(self.brainstem_doublevision, self.brainstem_swallow, self.cerebellar_vertigo,
									 merge_left_right(self.brainstem_laughfurrow_left, self.brainstem_laughfurrow_right),
									 self.brainstem_speakclear)

		nf4l= calc_nf4l(f4l)
		nf4u= calc_nf4u(f4u)
		nf4 = calc_nf4(nf4u, nf4l)

		nf5 = calc_nf5(f5t)

		nf6 = calc_nf6(self.calc_f6)

		nf7 = calc_nf7(self.calc_f7)

		tf8u = calc_tf8u(f8l, self.amb_ability_to_walk, self.functional_overall, f8u)
		tf8l = calc_tf8l(f8l, self.amb_ability_to_walk)
		nf8u = calc_nf8u(tf8u, f8u)
		nf8l = calc_nf8l(tf8l, f8l)
		nf8 = calc_nf8(nf8u, nf8l, f8h)

		nf9 = calc_nf9(self.amb_ability_to_walk, self.cerebellar_balance)

		nrs = nf1 + nf2 + nf3 + nf4 + nf6 + nf7 + nf8 + nf9 - nf5

		if nrs>=95
			nrs -= self.calc_sum_func_scores
		end

		self.calc_nrs = nrs
	end

	#### UI FUNCTIONS ####

	def record_ids(data)
		participant_ids = []
		data.each do |participant|
			participant_ids << participant["record_id"]
		end
	end

	def edss_histogram(data)
		edss_hash= {"0": 0, "1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0, "8": 0, "9": 0}
		data.each do |participant|
			edss_hash[:"#{(participant[:edss].floor).to_s}"] +=1
		end
		edss_hash
	end

	def sfs_histogram(data)
		sfs_hash= {"0":0, "5": 0, "10": 0, "15": 0, "20": 0, "25": 0, "30": 0, "35":0}
		data.each do |participant|
			hash_conversion = ((participant[:sfs]/5.0).ceil * 5).to_s
			sfs_hash[:"#{hash_conversion}"] += 1
		end
		 sfs_hash
	end

	def ai_histogram(data)
		ai_hash= {"0": 0, "1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0, "8": 0, "9": 0}
		data.each do |participant|
			ai_hash[:"#{(participant[:aI]).to_s}"] +=1
		end
		ai_hash

	end

	def calculate_f2h(f1h)
		if f1h>=2.5 
			f2h=f2h-0.5
		end
		return f2h
	end

	def calculate_nf1u(f1u, fs)
		nf1u=10
		if f1u==1 || f1u==2 
			nf1u=8
		elsif f1u==3 || f1u==4 
			nf1u=6
		elsif f1u==5 
			nf1u=2
		elsif f1u==6 
			nf1u=0
		end

		if f1u>=3 && fs<=2 
			nf1u=10
		end
		return nf1u
	end

	def calculate_nf1l(f1l, a1)
		nf1l=10
		if f1l==1 || f1l==2 
			nf1l=8
		elsif f1l==3 || f1l==4 
			nf1l=6
		elsif f1l==5 
			nf1l=2
		elsif f1l==6 
			nf1l=0
		end

		if f1l>=3 && a1<=2 
			nf1l=10
		end

		if f1l>=3 && a1==3 
			nf1l=6
		end

		if f1l>=5 && a1==4 
			nf1l=4
		end

		if f1l<=3 && a1>=6 && a1<8 
			nf1l=4
		end

		if f1l<=3 && a1>=8 
			nf1l=2
		end

		return nf1l
	end

	def calculate_nf1(nf1u, nf1l, f1h)
		nf1=nf1u+nf1l
		if f1h==1.5 
			nf1-=1
		elsif f1h==2 
			nf1-=2
		elsif f1h==2.5 
			nf1-=4
		elsif f1h==3 
			nf1-=6
		end
		return nf1
	end

	def calculate_nf2u(fs, f2u)
	 nf2u=5
		if f2u==1 || f2u==2 
			nf2u=4
		elsif f2u==3 || f2u==4 
			nf2u=3
		elsif f2u==5 
			nf2u=1
		elsif f2u==6 
			nf2u=0
		end

		if f2u>=3 && fs<=2 
			nf2u=4
		elsif f2u>=5 && fs==3 
			nf2u=3
		end

		return nf2u
	end

	def calculate_nf2l(f2l, a1)
	 nf2l=5
		if f2l==1 || f2l==2 
			nf2l=4
		elsif f2l==3 || f2l==4 
			nf2l=3
		elsif f2l==5 
			nf2l=1
		elsif f2l==6 
			nf2l=0
		end

		if f2l>=3 && a1<=2 
			nf2l=4
		elsif f2l>=3 && a1==3 
			nf2l=3
		elsif f2l>=5 && a1==4 
			nf2l=2
		elsif f2l<=3 && a1==6 
			nf2l=2
		elsif f2l<=3 && a1>=7 
			nf2l=1
		end

		return nf2l
	end

	def calculate_nf2(nf2u, nf2l, f2h)
	 nf2=nf2u+nf2l
		if f2h==2 
			nf2-=1
		elsif f2h==2.5 
			nf2-=2
		elsif f2h==3 
			nf2-=3
		end
		return nf2
	end

	def calculate_nf3(b1, b2, b3, f1f, f2s)
		nf3=15
		if b1<=1 && b3<=1 && (b1+b3)>0  && (b1+b3)<=2 
			nf3-=2
		elsif b1>1 && b3>1 && (b1+b3)<=3 
			nf3-=4
		end

		if (b1+b3)>3 && (b1+b3)<=5 
			nf3-=8 
		end

		if (b1+b3)==6 
			nf3-=10 
		end

		if f1f<=1 && b3<=1 && (f1f+b2)>0 && (f1f+b2)<=2 
			nf3-=1
		end

		if f2s==1 && (f1f+b2)==0 
			nf3-=1
		end

		if f1f>1 && b2>1 && (f1f+b2)<=3 
			nf3-=2 
		end

		if (f1f+b2)>3 && (f1f+b2)<=5 
			nf3-=4 
		end

		if f2s==2 && (f1f+b2)<=3 
			nf3-=4
		end

		if (f1f+b2)==6 || f2s==3 
			nf3-=5 
		end
		return nf3
	end

	def calculate_nf4u(f4u)
		nf4u=6
		if f4u>1 && f4u<=4 
			nf4u=4
		end

		if f4u==2 
			nf4u=5
		elsif f4u==5 
			nf4u=2
		elsif f4u==6 
			nf4u=0
		end
		return nf4u
	end

	def calculate_nf4l(f4l)
		nf4l=6
		if f4l>1 && f4l<=4 
			nf4l=4
		end

		if f4l==2 
			nf4l=5
		elsif f4l==5 
			nf4l=2
		elsif f4l==6 
			nf4l=0
		end
		return nf4l
	end

	def calculate_nf4(nf4u, nf4l)
		return nf4u+nf4l
	end

	def calculate_nf5(f5t)
		nf5=0
		if f5t>1 && f5t<=4 
			nf5=3
		elsif f5t>=5 && f5t<=6 
			nf5=7
		elsif f5t>6 
			nf5=10
		end
		return nf5
	end

	def calculate_nf6(f6)
		nf6=11
		if f6>1 && f6<3 
			nf6=7
		elsif f6>=3 && f6<=4 
			nf6=3
		elsif f6==5 
			nf6=0
		end
		return nf6
	end

	def calculate_nf7(f7)
		nf7=10
		if f7>1 && f7<=2 
			nf7=7
		elsif f7>=3 && f7<=4 
			nf7=4
		elsif f7==5 
			nf7=0
		end 
		return nf7
	end

	def calculate_nf8u(tf8u, f8u)
		nf8u=6
		if tf8u==1 
			nf8u=4
		end

		if f8u==1 
			nf8u=6
		elsif f8u==2 
			nf8u=5
		end

		if tf8u==2 
			nf8u=2
		elsif tf8u==3 
			nf8u=0
		end
		return nf8u
	end

	def calculate_nf8l(tf8l, f8l)
		nf8l=6
		if tf8l==1 
			nf8l=4
		end

		if f8l==1 
			nf8l=6
		elsif f8l==2 
			nf8l=5
		end

		if tf8l==2 
			nf8l=2
		elsif tf8l==3 
			nf8l=0
		end
		return nf8l
	end

	def calculate_nf8(nf8u, nf8l, f8h)
		nf8=nf8u+nf8l
		if f8h==2 
			nf8-=1
		elsif f8h==2.5 
			nf8-=2
		elsif f8h==3 
			nf8-=3
		end
		return nf8
	end

	def calculate_nf9(a1, bal)
		nf9=10
		if a1>2 && a1<=4 && bal<=1 
			nf9=7
		elsif a1>2 && a1<=4 && bal>=2 && bal<=3 
			nf9=5
		elsif a1==5 
			nf9=4
		elsif a1==6 
			nf9=2
		elsif a1>=7 
			nf9=0
		end
		return nf9
	end

	def sumh(f1h,f2h,f4h,f8h)
		return f1h+f2h+f4h+f8h
	end

	def sumu(tf1u,tf2u,tf4u,tf8u)
		return tf1u+tf2u+tf4u+tf8u
	end

	def suml(tf1l,tf2l,tf4l,tf8l)
		return tf1l+tf2l+tf4l+tf8l
	end

	def sumq(sumu,suml)
		return sumu+suml
	end

	def sump(suml,sumu)
		return suml-sumu
	end

	def pctu(sumu)
		return (15-sumu)/15
	end

	def pctl(suml)
		return (15-suml)/15
	end

	def pcth(sumh)
		return sumh/12
	end

	def pctp(sump)
		return sump/15
	end

	def pctq(sumq)
		return sumq/30
	end

	def calc_sue(nf1u,nf2u,nf4u,nf8u)
		return nf1u+nf2u+nf4u+nf8u
	end

	def calc_sle(nf1l,nf2l,nf4l,nf8l,nf9)
		return nf1l+nf2l+nf4l+nf8l+nf9
	end

	def calc_pctue(sue)
		return sue/25
	end

	def calc_pctle(sle)
		return sle/39
	end

	def calculate_mds(edss, nrs, aI, fs, sfs)
		return ((edss*0.211+(100-nrs)*0.033+aI*0.322+(fs-1)*0.69+sfs[:sfs]*0.085).round(2)).floor
	end

	def calc_mdsx(edss, nrs, aI, fs, sfs)
		return (edss+1)*0.211*(101-nrs)*0.033*(ai+1)*0.322*(fs)*0.69*(sfs+1)*0.085
	end

	def calc_edss2(edss)
		return edss*edss
	end

	def calc_mds2(mds)
		return mds*mds
	end

	def calc_tedssx(edss)
		return Math.exp(edss)
	end

	def calc_tmdsx(mds)
		return Math.exp(mds)
	end
end