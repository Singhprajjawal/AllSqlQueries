
		--Select Top 10 rows from StudentsPerformance dataset
		select top 10 * from StudentsPerformance

		--------------------------------------------------------
		Select top 10 gender,parental_level_of_education,
		lunch,
		test_preparation_course,
		math_score,
		rank() over (order by math_score desc) as rnk,
		dense_rank() over (order by math_score desc) as dens_rank,
		row_number() over (order by math_score desc) as row_num
		from StudentsPerformance

		----------------------------------------------------------------------------------
		--Used partition by clause 
		-----------------------------------------------------------------------------------
		Select top 10 gender,parental_level_of_education,lunch,test_preparation_course,
		rank() over ( partition by  Race_group order by math_score desc) as r_nk
		from StudentsPerformance

		-----------------------------------------------------------------------------------
		
		Select top 12 s.*, max(math_score) over (partition by lunch ) as mx
		from StudentsPerformance s

		------------------------------------------------------------------------------------------------
		Select s.Race_group,s.lunch,s.parental_level_of_education,s.test_preparation_course,s.math_score,
		ROW_NUMBER() over (partition by parental_level_of_education order by math_score desc) as row_num
		from StudentsPerformance s
		
		-----------------------------------------------------------------------------------------
		
		Select * from (
		Select s.Race_group,s.lunch,s.parental_level_of_education,s.test_preparation_course,s.math_score,
		RANK() over (partition by test_preparation_course order by math_score desc) as r_nk
		from StudentsPerformance s) d
		where d.r_nk<9
		
		---------------------------------------------------------------------------------------------------
		
		Select * from (
		Select s.Race_group,s.lunch,
		s.parental_level_of_education,
		s.test_preparation_course,
		s.math_score,
		Dense_RANK() over (partition by test_preparation_course order by math_score desc) as dense_rnk
		from StudentsPerformance s) d
		where d.dense_rnk<9
		
		--------------------------------------------------------------------------------------------------
		--lead and lag
		
		select w.* ,
		lag(math_score) over ( order by math_score desc) as previous_value
		from StudentsPerformance w
		
		------------------------------------------------------------------------------------------
		
		select w.* ,
		lead(math_score) over ( partition by lunch order by math_score desc) as next_value
		from StudentsPerformance w
		------------------------------------------------------------------------------------

		-------percent rank

		Select *,
		concat(Round(PERCENT_RANK() over (order by math_score desc) *100,2),'%') as per_rank
		from StudentsPerformance
		--------------------------------------------------------------------------------------------

		------Ntile function

		Select x.gender,
		x.math_score,
		x.parental_level_of_education,
		x.Race_group,
		case
				when x.math_score between 90 and 100 then 'excellent Marks'
				when x.math_score between 80 and 90 then 'better Marks'
				when x.math_score between 70 and 80 then 'good Marks'
				when x.math_score <70               then 'poor Marks' 
				end as category_of_marks
		from
			(Select *,
			NTILE(8) over (order by math_score desc) as n_tile
			from StudentsPerformance
			where parental_level_of_education='bachelor''s degree')x order by Race_group Asc

		-----------------------------------------------------------------------------------------------
