class GoodinCalculation
	attr_reader :data_set

	def initialize(redcap_data)
		@data_set = []
		redcap_data.each do |participant|
			sfs = calculate_sfs(participant)
			edss = calculate_edss(participant, sfs)
			aI = calculate_AI(participant)
			nrs = calculate_nrs(participant, sfs)	
			mds = calculate_mds(edss, nrs, aI, participant["fs"].to_i, sfs)
			data = {record_id: participant["record_id"].to_i, first_name: participant["first_name"], sfs: sfs[:sfs], edss: edss, aI: aI, nrs: nrs, mds: mds}
			@data_set<< data
		end
	end

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

	def calc_tf1u(f1u,fs)
		tf1u=0
		if f1u==1 || f1u==2 
			tf1u=1
		elsif f1u==3 
			tf1u=2
		elsif f1u==4 
			tf1u=3
		elsif f1u>4
		 tf1u=4
		end

		if f1u>4 && fs<=2 
			tf1u=3
		end

		return tf1u
	end


	def calc_tf1l(f1l, a1)
		tf1l=0
		if f1l==1 || f1l==2 
			tf1l=1
		elsif f1l==3 
			tf1l=2
		elsif f1l==4 
			tf1l=3
		elsif f1l>4 
			tf1l=4
		end

		if f1l>=3 && a1<=2 
			tf1l=1
		elsif f1l>=3 && a1==3 
			tf1l=2
		elsif f1l>=5 && a1==4 
			tf1l=3
		end

		return tf1l
	end

	def calc_f1(tf1l, tf1u, f1h)
		f1=0
		if tf1l>=tf1u 
			f1=tf1l
		else
			f1=tf1u
		end

		if f1<2 && f1h==2 
			f1=2
		elsif f1<3 && f1h==2.5 
			f1=3
		elsif f1<3 && (tf1u+tf1l)>=4 && (tf1u+tf1l)<=5 
			f1=3
		elsif f1h==3 
			f1=4
		elsif (tf1u+tf1l)>=6 && (tf1u+tf1l)<=7 
			f1=4    
		elsif (tf1u+tf1l)==8 
			f1=5 
		end   
		return f1
	end

	def calc_tf2u(f2u, tf1u, fs)
		tf2u=0
		if f2u==1 || f2u==2 
			tf2u=1
		elsif f2u==3 
			tf2u=2
		elsif f2u==4 
			tf2u=3
		elsif f2u>4 
			tf2u=4
		end

		if f2u>4 && fs<=2 
			tf2u=3
		end

		if tf1u>=3 && tf2u>=3 
			tf2u-=1
		end

		return tf2u
	end

	def calc_tf2l(f2l, a1, tf1l, f1h)
		tf2l=0
		if f2l==1 || f2l==2 
			tf2l=1
		elsif f2l==3 
			tf2l=2
		elsif f2l==4 
			tf2l=3
		elsif f2l>4 
			tf2l=4
		end

		if f2l>=3 && a1<=2 
			tf2l=1
		elsif f2l>=3 && a1==3 
			tf2l=2
		elsif f2l>=5 && a1==4 
			tf2l=3
		end

		if tf1l>=3 && tf2l>=3 
			tf2l-=1
		end

		return tf2l
	end

	def calc_f2h(f1h)
		if f1h>=2.5 
			f2h=f2h-0.5
		end
		return f2h
	end

	def calc_f2(tf2l,tf2u,f2h)
		f2=0
		if tf2l>=tf2u 
			f2=tf2l
		else 
			f2=tf2u
		end

		if f2<2 && f2h==2 
			f2=2
		elsif f2<3 && f2h==2.5 
			f2=3
		end

		if f2<3 && (tf2u+tf2l)>=4 && (tf2u+tf2l)<=5 
			f2=3
		end

		if f2h==3 
			f2=4
		end

		if (tf2u+tf2l)>=6 && (tf2u+tf2l)<=7 
			f2=4    
		end

		if (tf2u+tf2l)==8 
			f2=5  
		end

		return f2

	end

	def calc_f3(f2s, f1f, b1, b2, b3, f1)
		sbs=f2s+f1f+b1+b2+b3
		f3=0
		if f2s==3 || f1f==3 
			f3=4
		end
		if b1==3 && f3<4 
			f3=3
		end
		if f3==4 && b2==3 
			f3=5
		end

		if sbs<=5 && f3<=2 
			f3=1
		elsif sbs>=6 && f3<=2 
			f3=2
		end
		
		if sbs==0 
			f3=0
		end
		return f3
	end

	def calc_tf4u(fs, f4u)
		tf4u=0
		if f4u==1 || f4u==2 
			tf4u=1
		elsif f4u==3 
			tf4u=2
		elsif f4u==4 
			tf4u=3
		elsif f4u>=5 
			tf4u=4
		end

		if f4u>4 && fs<=2 
			tf4u=3
		end
		return tf4u
	end

	def calc_tf4l(f4l, a1)
		tf4l=0
		if f4l==1 || f4l==2 
			tf4l=1
		elsif f4l==3 
			tf4l=2
		elsif f4l==4 
			tf4l=3
		elsif f4l>=5 
			tf4l=4
		end
		
		if f4l>4 && a1<=2 
			tf4l=tf4l-1
		end
		return tf4l
	end

	def calc_f4(tf4l, tf4u, f4h)
		f4=0
		if tf4l>=tf4u 
			f4=tf4l
		else 
			f4=tf4u
		end

		if f4<2 && f4h==2 
			f4=2
		end

		if f4<3 && (tf4u+tf4l)>=4 && (tf4u+tf4l)<=5 
			f4=3
		end

		if f4<3 && f4h==2.5 
			f4=3
		end

		if f4h==3 
			f4=4
		end

		if (tf4u+tf4l)>=6 && (tf4u+tf4l)<=7 
			f4=4    
		elsif (tf4u+tf4l)==8 
			f4=5    
		end
		return f4
	end

	def calc_f5(f5t)
		if f5t==1 
			f5=0
		elsif f5t>1 && f5t<=4 
			f5=1
		elsif f5t==5 
			f5=2
		elsif f5t==6 
			f5=3
		elsif f5t==7 || f5t==8 
			f5=4
		else
			f5=5
		end
		return f5
	end

	def calc_f6(f6t)
		f6=0
		if f6t>=1 && f6t<=2 
			f6=1
		elsif f6t==3 
			f6=2
		elsif f6t==4 
			f6=3
		elsif f6t==5 
			f6=4
		elsif f6t==6 
			f6=5
		end
		return f6
	end

	def calc_f7(f7t, c1)
		 f7=f7t
		if f7t==1 
			f7=0
		end

		if c1>1 && f7==0 
			f7=1
		end

		if f7==2 
			f7=1
		end

		if f7>1 && c1==2 
			f7=f7-1
		end

		return f7
	end

	def calc_tf8u(f8l, a1, fs, f8u)
		tf8u=0
		if f8u==1 || f8u==2 
			tf8u=1
		elsif f8u>=3 && f8u<=4 
			tf8u=2
		end

		if f8l>=4 && a1<=2 && tf8u>=2 
			tf8u=tf8u-1  
		end

		if f8u>4 && fs<=2 
			tf8u=2
		end

		if f8u>4 
			tf8u=3
		end
		return tf8u
	end

	def calc_tf8l(f8l, a1)
		tf8l=0
		if f8l==1 || f8l==2 
			tf8l=1
		elsif f8l>=3 && f8l<=4 
			tf8l=2
		end

		if f8l>=3 && a1>=3 && a1<=4 
			tf8l=2
		end

		if f8l>=3 && a1<=2 
			tf8l=1
		end

		if f8l>4 
			tf8l=3
		end
		return tf8l
	end

	def calc_f8(tf8l, tf8u, f8h)
		f8=0
		if tf8l>=tf8u 
			f8=tf8l
		else
			f8=tf8u
		end

		if f8<2 && f8h==2 
			f8=2
		end

		if (tf8u+tf8l)>=4 
			f8=3
		end

		if f8h>2 
			f8=3
		end

		return f8
	end

	def calculate_sfs(redcap_data)
		f1u = redcap_data["f1a"].to_i + redcap_data["f1b"].to_i
		f1l = redcap_data["f1c"].to_i + redcap_data["f1d"].to_i
		f2l = redcap_data["f2c"].to_i + redcap_data["f2d"].to_i
		f2u = redcap_data["f2a"].to_i + redcap_data["f2b"].to_i
		f1h = ((redcap_data["f1a"].to_i + redcap_data["f1c"].to_i) - (redcap_data["f1b"].to_i + redcap_data["f1d"].to_i)).abs / 2.0
		f2h = ((redcap_data["f2a"].to_i + redcap_data["f2c"].to_i) - (redcap_data["f2b"].to_i + redcap_data["f2d"].to_i)).abs / 2.0

		f4h = ((redcap_data["f4a"].to_i + redcap_data["f4c"].to_i) - (redcap_data["f4b"].to_i + redcap_data["f4d"].to_i)).abs / 2.0
		f4u = redcap_data["f4a"].to_i + redcap_data["f4b"].to_i
		f4l = redcap_data["f4c"].to_i + redcap_data["f4d"].to_i

		f5t = [redcap_data["f5ta"].to_i, redcap_data["f5tb"].to_i].max
		f6t = redcap_data["f6a"].to_i + redcap_data["f6b"].to_i
		f8l = redcap_data["f8c"].to_i + redcap_data["f8d"].to_i
		f8u = redcap_data["f8a"].to_i + redcap_data["f8b"].to_i
		f8h = ((redcap_data["f8a"].to_i + redcap_data["f8c"].to_i) - (redcap_data["f8b"].to_i + redcap_data["f8d"].to_i)).abs / 2.0

		tf1l=self.calc_tf1l(f1l, redcap_data["a1"].to_i)
		tf1u=self.calc_tf1u(f1u,redcap_data["fs"].to_i)
		f1=self.calc_f1(tf1l, tf1u, f1h)

		tf2l=self.calc_tf2l(f2l, redcap_data["a1"].to_i, tf1l, f1h)
		tf2u=self.calc_tf2u(f2u, tf1u, redcap_data["fs"].to_i)
		f2=self.calc_f2(tf2l,tf2u,f2h)

		f3=self.calc_f3(redcap_data["f2s"].to_i, redcap_data["f1f"].to_i, redcap_data["b1"].to_i, redcap_data["b2"].to_i, redcap_data["b3"].to_i, f1)

		tf4l=self.calc_tf4l(f4l, redcap_data["a1"].to_i)
		tf4u=self.calc_tf4u(redcap_data["fs"].to_i, f4u)	
		f4=self.calc_f4(tf4l, tf4u, f4h)

		f5=self.calc_f5(f5t)

		f6=self.calc_f6(f6t)

		f7=self.calc_f7(redcap_data["f7t"].to_i, redcap_data["c1"].to_i)

		tf8l=self.calc_tf8l(f8l, redcap_data["a1"].to_i)
		tf8u=self.calc_tf8u(f8l, redcap_data["a1"].to_i, redcap_data["fs"].to_i, f8u)
		f8=self.calc_f8(tf8l, tf8u, f8h)

		sfs = f1+f2+f3+f4+f5+f6+f7+f8

		return {sfs: sfs, f1: f1, f2: f2, f3: f3, f4: f4, f5: f5, f6: f6, f7: f7, f8: f8}
	end

	def calc_f_num(f_hash)
		fs2 = 0
		fs3 = 0
		fs4 = 0
		fs5 = 0

		if f_hash[:f1]==2 
			fs2=fs2+1
		elsif f_hash[:f1]==3 
			fs3=fs3+1
		elsif f_hash[:f1]==4
			fs4=fs4+1
		elsif f_hash[:f1]>4
			fs5=fs5+1
		end

		if f_hash[:f2]==2 
			fs2=fs2+1
		elsif f_hash[:f2]==3 
			fs3=fs3+1
		elsif f_hash[:f2]==4
			fs4=fs4+1
		elsif f_hash[:f2]>4
			fs5=fs5+1
		end

		if f_hash[:f3]==2 
			fs2=fs2+1
		elsif f_hash[:f3]==3 
			fs3=fs3+1
		elsif f_hash[:f3]==4
			fs4=fs4+1
		elsif f_hash[:f3]>4
			fs5=fs5+1
		end

		if f_hash[:f4]==2 
			fs2=fs2+1
		elsif f_hash[:f4]==3 
			fs3=fs3+1
		elsif f_hash[:f4]==4
			fs4=fs4+1
		elsif f_hash[:f4]>4
			fs5=fs5+1
		end

		if f_hash[:f5]==2 
			fs2=fs2+1
		elsif f_hash[:f5]==3 
			fs3=fs3+1
		elsif f_hash[:f5]==4
			fs4=fs4+1
		elsif f_hash[:f5]>4
			fs5=fs5+1
		end

		if f_hash[:f6]==2 
			fs2=fs2+1
		elsif f_hash[:f6]==3 
			fs3=fs3+1
		elsif f_hash[:f6]==4
			fs4=fs4+1
		elsif f_hash[:f6]>4
			fs5=fs5+1
		end

		if f_hash[:f7]==2 
			fs2=fs2+1
		elsif f_hash[:f7]==3 
			fs3=fs3+1
		elsif f_hash[:f7]==4
			fs4=fs4+1
		elsif f_hash[:f7]>4
			fs5=fs5+1
		end

		if f_hash[:f8]==2 
			fs2=fs2+1
		elsif f_hash[:f8]==3 
			fs3=fs3+1
		elsif f_hash[:f8]==4
			fs4=fs4+1
		elsif f_hash[:f8]>4
			fs5=fs5+1
		end

		return {fs2: fs2, fs3: fs3, fs4: fs4, fs5: fs5}
	end

	def calculate_edss(redcap_data, sfs_hash)
		fs_nums = calc_f_num(sfs_hash)
		fs2= fs_nums[:fs2] 
		fs3= fs_nums[:fs3] 
		fs4= fs_nums[:fs4] 
		fs5= fs_nums[:fs5] 
		a1= redcap_data["a1"].to_i
		fs= redcap_data["fs"].to_i
		a21= redcap_data["a21"].to_i 
		a22= redcap_data["a22"].to_i 
		a23= redcap_data["a23"].to_i  
		a24= redcap_data["a24"].to_i

		edss=4
		if sfs_hash[:sfs]==0 
			edss=0
		elsif sfs_hash[:sfs]==1 
			edss=1
		elsif fs2==0 && fs3==0 && fs4==0 && fs5==0 && sfs_hash[:sfs]==2 
			edss=1.5
		elsif fs2==0 && fs3==0 && fs4==0 && fs5==0 && sfs_hash[:sfs]>2 
			edss=2
		elsif fs2==1 && fs3==0 && fs4==0 && fs5==0 
			edss=2 
		elsif fs2==2 && fs3==0 && fs4==0 && fs5==0 
			edss=2.5
		elsif fs2<=1 && fs3==1 && fs4==0 && fs5==0 
			edss=3
		elsif fs2>=3 && fs2<=4 && fs3==0 && fs4==0 && fs5==0 
			edss=3
		elsif fs2>=2 && fs2<=3 && fs3==1 && fs4==0 && fs5==0 
			edss=3.5 
		elsif fs2==0 && fs3==2 && fs4==0 && fs5==0 
			edss=3.5 
		elsif fs2==5 && fs3==0 && fs4==0 && fs5==0 
			edss=3.5 
		elsif fs2==0 && fs3==0 && fs4==1 && fs5==0 
			edss=3.5
		end

		if a1==3 && fs<=2 
			edss=4.5
		elsif a1>=2 && a1<=3 && fs>=3 
			edss=5
		elsif a1>=4 && a1<=5 && fs==1 
			edss=4.5 
		elsif a1>=4 && a1<=5 && fs==2 
			edss=5
		elsif a1>=4 && a1<=5 && fs>=3 
			edss=5.5 
		elsif a1==6 && fs<=2 && a21>=80 
			edss=5.0
		elsif a1==6 && fs>=3 && a21>=80 
			edss=5.5
		elsif a1==6 && fs<=2 && a21>=60 && a21<80 
			edss=5.5
		elsif a1==6 && fs>=3 && a21>=60 && a21<80 
			edss=6 
		elsif a1==6 && a21<60 && (a23+a24)<50 
			edss=6
		elsif a1==6 && (a23+a24)>=50 
			edss=6.5
		elsif a1>=7 && a1<=8 && (a23+a24)<=20 && a22<20 
			edss=5.5
		elsif a1>=7 && a1<=8 && (a23+a24)<=20 && a22>=20 
			edss=6  
		elsif a1>=7 && a1<=8 && (a23+a24)>20 && a24<40 
			edss=6.5  
		elsif a1==7 && (a23+a24)>20 && (a23+a24)<60 && a24>=40 
			edss=6.5  
		elsif a1==7 && (a23+a24)>20 && (a23+a24)>=60 && a24>=40 
			edss=7 
		elsif a1==8 && (a23+a24)>20 && (a23+a24)<50 && a24>=40 
			edss=6.5  
		elsif a1==8 && (a23+a24)>20 && (a23+a24)>=50 && a24>=40 
			edss=7 
		elsif a1==9 && fs<=3 
			edss=7
		elsif a1==9 && fs==4  && sfs_hash[:sfs]<20 
			edss=7.5
		elsif a1==9 && fs==4 && sfs_hash[:sfs]>=20 
			edss=8
		elsif a1==9 && fs==5 && sfs_hash[:sfs]<=15 
			edss=7.5
		elsif a1==9 && fs==5 && sfs_hash[:sfs]>15 
			edss=8
		elsif a1==10 && fs<5 
			edss=8  
		elsif a1==10 && fs==5 && sfs_hash[:sfs]<20 
			edss=8.5
		elsif a1==10 && fs==5 && sfs_hash[:sfs]>=20 && sfs_hash[:sfs]<30 
			edss=9
		elsif a1==10 && fs==5 && sfs_hash[:sfs]>=30 
			edss=9.5
		end
		return edss
	end

	def calculate_AI(redcap_data)
		a1= redcap_data["a1"].to_i 
		a21= redcap_data["a21"].to_i
		a22= redcap_data["a22"].to_i
		a23= redcap_data["a23"].to_i
		a24= redcap_data["a24"].to_i
		fs = redcap_data["fs"].to_i

		data = {a1: a1, a21: a21, a22: a22, a23: a23, a24: a24, fs: fs}

		aI = 0
		if a1==1 
			aI=0
		elsif a1==2 
			aI=1
		elsif a1>=3 && a1<=4 
			aI=2
		elsif a1==5 && a21>=20 && (a23+a24)<=10 
			aI=3
		elsif a1==5 && a21>=20 && (a23+a24)>=10 
			aI=4
		elsif a1==5 && a21<20 
			aI=4
		elsif a1==6 && (a23+a24)<50 && a24<=20 
			aI=4 
		elsif a1==6 && (a23+a24)>=50 && a24<=20 
			aI=5
		elsif a1==6 && a24>20 
			aI=6
		end

		if a1==6 && (a21+a22)>=80 
			aI=4 
		end

		if a1==6 && a21>=80 
			aI=3
		elsif a1>=7 && a1<=8 && (a23+a24)<50 && a24<=20 
			aI=5
		elsif a1>=7 && a1<=8 && (a23+a24)<50 && a24>20 
			aI=6 
		elsif a1>=7 && a1<=8 && (a23+a24)>=50 && a24<=20 
			aI=6 
		elsif a1>=7 && a1<=8 && (a23+a24)>=50 && a24>20 
			aI=7 
		end
		
		if a1>=7 && a1<=8 && (a21+a22)>=80 
			aI=4 
		end

		if a1>=7 && a1<=8 && a21>=80 
			aI=3
		end

		if a1==9 && fs<=2 
			aI=7
		elsif a1==9 && fs>2 
			aI=8
		end

		if a1==10 && fs<=4 
			aI=8
		elsif a1==10 && fs==5 
			aI=9
		end
		return aI
	end

	def calc_nf1u(f1u, fs)
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

	def calc_nf1l(f1l, a1)
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


	def calc_nf1(nf1u, nf1l, f1h)
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

	def calc_nf2u(fs, f2u)
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

	def calc_nf2l(f2l, a1)
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

	def calc_nf2(nf2u, nf2l, f2h)
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

	def calc_nf3(b1, b2, b3, f1f, f2s)
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

	def calc_nf4u(f4u)
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

	def calc_nf4l(f4l)
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

	def calc_nf4(nf4u, nf4l)
		return nf4u+nf4l
	end

	def calc_nf5(f5t)
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

	def calc_nf6(f6)
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

	def calc_nf7(f7)
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

	def calc_nf8u(tf8u, f8u)
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

	def calc_nf8l(tf8l, f8l)
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

	def calc_nf8(nf8u, nf8l, f8h)
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

	def calc_nf9(a1, bal)
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

	def calculate_nrs (redcap_data, sfs)
		f1u = redcap_data["f1a"].to_i + redcap_data["f1b"].to_i
		f1l = redcap_data["f1c"].to_i + redcap_data["f1d"].to_i
		f2l = redcap_data["f2c"].to_i + redcap_data["f2d"].to_i
		f2u = redcap_data["f2a"].to_i + redcap_data["f2b"].to_i
		f1h = ((redcap_data["f1a"].to_i + redcap_data["f1c"].to_i) - (redcap_data["f1b"].to_i + redcap_data["f1d"].to_i)).abs / 2.0
		f2h = ((redcap_data["f2a"].to_i + redcap_data["f2c"].to_i) - (redcap_data["f2b"].to_i + redcap_data["f2d"].to_i)).abs / 2.0

		f4h = ((redcap_data["f4a"].to_i + redcap_data["f4c"].to_i) - (redcap_data["f4b"].to_i + redcap_data["f4d"].to_i)).abs / 2.0
		f4u = redcap_data["f4a"].to_i + redcap_data["f4b"].to_i
		f4l = redcap_data["f4c"].to_i + redcap_data["f4d"].to_i

		f5t = [redcap_data["f5ta"].to_i, redcap_data["f5tb"].to_i].max
		f6t = redcap_data["f6a"].to_i + redcap_data["f6b"].to_i
		f8l = redcap_data["f8c"].to_i + redcap_data["f8d"].to_i
		f8u = redcap_data["f8a"].to_i + redcap_data["f8b"].to_i
		f8h = ((redcap_data["f8a"].to_i + redcap_data["f8c"].to_i) - (redcap_data["f8b"].to_i + redcap_data["f8d"].to_i)).abs / 2.0

		nf1l = calc_nf1l(f1l, redcap_data["a1"].to_i)
		nf1u = calc_nf1u(f1u, redcap_data["fs"].to_i)
		nf1 = calc_nf1(nf1u, nf1l, f1h)

		nf2l = calc_nf2l(f2l, redcap_data["a1"].to_i)
		nf2u = calc_nf2u(redcap_data["fs"].to_i, f2u)
		nf2 = calc_nf2(nf2u, nf2l, f2h)
		
		nf3 = calc_nf3(redcap_data["b1"].to_i, redcap_data["b2"].to_i, redcap_data["b3"].to_i, redcap_data["f1f"].to_i, redcap_data["f2s"].to_i)

		nf4l= calc_nf4l(f4l)
		nf4u= calc_nf4u(f4u)
		nf4 = calc_nf4(nf4u, nf4l)

		nf5 = calc_nf5(f5t)

		nf6 = calc_nf6(sfs[:f6])

		nf7 = calc_nf7(sfs[:f7])

		tf8u = calc_tf8u(f8l, redcap_data["a1"].to_i, redcap_data["fs"].to_i, f8u)
		tf8l = calc_tf8l(f8l, redcap_data["a1"].to_i)
		nf8u = calc_nf8u(tf8u, f8u)
		nf8l = calc_nf8l(tf8l, f8l)
		nf8 = calc_nf8(nf8u, nf8l, f8h)

		nf9 = calc_nf9(redcap_data["a1"].to_i, redcap_data["bal"].to_i)
		
		nrs=nf1+nf2+nf3+nf4-nf5+nf6+nf7+nf8+nf9
		if nrs>=95 
			nrs-=sfs[:sfs]
		end

		return nrs
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
