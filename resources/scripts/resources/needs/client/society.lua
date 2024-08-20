function OpenBossMenu(society, close, options)
	options = options or {}
	local elements = {}

	ESX.TriggerServerCallback('esx_society:isBoss', function(isBoss)
		if isBoss then
			local defaultOptions = {
				checkBal = true,
				withdraw = true,
				deposit = true,
				wash = true,
				employees = true,
				salary = true,
				grades = true
			}

			for k,v in pairs(defaultOptions) do
				if options[k] == nil then
					options[k] = v
				end
			end

			if options.checkBal then
				elements[#elements+1] = {
					icon = "fas fa-wallet", 
					title = 'Check Blance', 
					value = "check_society_balance",
					onSelect = function()
						TriggerServerEvent('esx_society:checkSocietyBalance', society)
					end
				}
			end
			if options.withdraw then
				elements[#elements+1] = {
					icon = "fas fa-wallet", 
					title = 'Withdraw Money', 
					value = "withdraw_society_money",
					onSelect = function()
						local input = lib.inputDialog('', {{type = 'number', label = 'Withdraw Amount', description = '', icon = 'hashtag'}})
						if not input then return end
						if input[1] == nil then
							ZenDevelopment.SendNotify('Invalid Amount', 'error')
						else
							TriggerServerEvent('esx_society:withdrawMoney', society, input[1])
						end
					end
				}
			end
			if options.deposit then
				elements[#elements+1] = {
					icon = "fas fa-wallet", 
					title = 'Deposit Money', 
					value = "deposit_money",
					onSelect = function()
						local input = lib.inputDialog('', {{type = 'number', label = 'Deposit Amount', description = '', icon = 'hashtag'}})
						if not input then return end
						if input[1] == nil then
							ZenDevelopment.SendNotify('Invalid Amount', 'error')
						else
							TriggerServerEvent('esx_society:depositMoney', society, input[1])
						end
					end
				}
			end
			if options.wash then
				elements[#elements+1] = {
					icon = "fas fa-wallet", 
					title = 'Wash Money', 
					value = "wash_money",
					onSelect = function()
						local input = lib.inputDialog('', {{type = 'number', label = 'Wash Amount', description = '', icon = 'hashtag'}})
						if not input then return end
						if input[1] == nil then
							ZenDevelopment.SendNotify('Invalid Amount', 'error')
						else
							TriggerServerEvent('esx_society:washMoney', society, input[1])
						end
					end
				}
			end
			if options.employees then
				elements[#elements+1] = {
					icon = "fas fa-users", 
					title = 'Manage Employees', 
					value = "manage_employees",
					onSelect = function()
						OpenManageEmployeesMenu(society, options)
					end
				}
			end
			if options.salary then
				elements[#elements+1] = {
					icon = "fas fa-wallet", 
					title = 'Manage Salary', 
					value = "manage_salary",
					onSelect = function()
						OpenManageSalaryMenu(society, options)
					end
				}
			end
			if options.grades then
				elements[#elements+1] = {
					icon = "fas fa-scroll", 
					title = 'Manage Ranks', 
					value = "manage_grades",
					onSelect = function()
						OpenManageGradesMenu(society, options)
					end
				}
			end

			lib.registerContext({
				id = 'society_1',
				title = 'BOSS MENU', 
				options = elements
			})
			lib.showContext('society_1')

			
		end
	end, society)
end

function OpenManageEmployeesMenu(society, options)
	local elements = {
		{icon = "fas fa-users", title = 'Employee List', onSelect = function() OpenEmployeeList(society, options) end },
		{icon = "fas fa-users", title = 'Recruit Player', onSelect = function() OpenRecruitMenu(society, options) end }
	}
	
	elements[#elements+1] = {icon = "fas fa-arrow-left", title = "Return", onSelect = function() OpenBossMenu(society, nil, options) end}

	lib.registerContext({
		id = 'society_2',
		title = 'Employee Management', 
		options = elements
	})
	lib.showContext('society_2')
end

function OpenEmployeeList(society, options)
	ESX.TriggerServerCallback('esx_society:getEmployees', function(employees)
		local elements = {}

		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].job.grade_label == '' and employees[i].job.label or employees[i].job.grade_label)
			local employee = employees[i]
			elements[#elements+1] = {
				icon = "fas fa-user", 
				title = employees[i].name .. " | " ..gradeLabel, 
				gradeLabel = gradeLabel, 
				data = employees[i],
				onSelect = function()
					local elements2 = {
						{
							icon = "fas fa-user", 
							title = "Promote", 
							value = "promote",
							onSelect = function()
								OpenPromoteMenu(society, employee, options)
							end
						},
						{
							icon = "fas fa-user", 
							title = "Fire", 
							value = "fire",
							onSelect = function()
								ZenDevelopment.SendNotify('You Fired '..employee.name, 'error')
	
								ESX.TriggerServerCallback('esx_society:setJob', function()
									OpenEmployeeList(society, options)
								end, employee.identifier, 'unemployed', 0, 'fire')
							end
						},
						{
							icon = "fas fa-arrow-left", 
							title = "Return", 
							value = "return",
							onSelect = function()
								OpenEmployeeList(society, options)
							end
						}
					}
					lib.registerContext({
						id = 'society_4',
						title = employees[i].name .. " | " ..gradeLabel, 
						options = elements2
					})
					lib.showContext('society_4')
				end
			}
		end

		elements[#elements+1] = {icon = "fas fa-arrow-left", title = "Return", onSelect = function() OpenManageEmployeesMenu(society, options) end }

		lib.registerContext({
			id = 'society_3',
			title = "Employees", 
			options = elements
		})
		lib.showContext('society_3')
	end, society)
end

function OpenRecruitMenu(society, options)
	ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
		local elements = {}

		for i=1, #players, 1 do
			if players[i].job.name ~= society then
				elements[#elements+1] = {
					icon = "fas fa-user", 
					title = players[i].name, 
					value = players[i].source, 
					name = players[i].name, 
					identifier = players[i].identifier,
					onSelect = function()
						local elements2 = {
							{icon = "fas fa-times", title = 'np', value = "no"},
							{
								icon = "fas fa-check", 
								title = 'yes', 
								onSelect = function() 
									ZenDevelopment.SendNotify('You have hired '..players[i].name, 'success')
		
									ESX.TriggerServerCallback('esx_society:setJob', function()
										OpenRecruitMenu(society, options)
									end, players[i].identifier, society, 0, 'hire')
								end
							},
						}
						lib.registerContext({
							id = 'society_6',
							title = "Confirmation", 
							options = elements2
						})
						lib.showContext('society_6')
					end
				}
			end
		end

		elements[#elements+1] = {icon = "fas fa-arrow-left", title = "Return", onSelect = function() OpenManageEmployeesMenu(society, options) end}

		lib.registerContext({
			id = 'society_5',
			title = 'Recruiting', 
			options = elements
		})
		lib.showContext('society_5')
	end)
end

function OpenPromoteMenu(society, employee, options)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		if not job then
			return
		end

		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			elements[#elements+1] = {
				icon = "fas fa-user", 
				title = gradeLabel, 
				value = job.grades[i].grade, 
				selected = (employee.job.grade == job.grades[i].grade),
				onSelect = function() 
					ZenDevelopment.SendNotify('You have promoted '..employee.name..' to '..gradeLabel, 'success')

					ESX.TriggerServerCallback('esx_society:setJob', function()
						OpenEmployeeList(society, options)
					end, employee.identifier, society, job.grades[i].grade, 'promote')
				end
			}
		end

		elements[#elements+1] = {icon = "fas fa-arrow-left", title = "Return", onSelect = function() OpenEmployeeList(society, options) end}

		lib.registerContext({
			id = 'society_7',
			title = 'Promote '..employee.name, 
			options = elements
		})
		lib.showContext('society_7')
	end, society)
end

function OpenManageSalaryMenu(society, options)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		if not job then
			return
		end

		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			elements[#elements+1] = {
				icon = "fas fa-wallet",
				title = gradeLabel..' - $'..ESX.Math.GroupDigits(job.grades[i].salary),
				value = job.grades[i].grade,
				onSelect = function()
					local input = lib.inputDialog('', {{type = 'number', label = 'Grade Salary Amount', description = '', icon = 'hashtag'}})
					if not input then return end
					if input[1]  == nil then
						ZenDevelopment.SendNotify('Invalid Amount', 'error')
						OpenManageSalaryMenu(society, options)
					elseif input[1]  > societyConfig.MaxSalary then
						ZenDevelopment.SendNotify('That is over the max salary!', 'error')
						OpenManageSalaryMenu(society, options)
					else
						ESX.TriggerServerCallback('esx_society:setJobSalary', function()
							OpenManageSalaryMenu(society, options)
						end, society, job.grades[i].grade, input[1] )
					end
				end
			}
		end
			
		elements[#elements+1] = {icon = "fas fa-arrow-left", title = "Return", onSelect = function() OpenBossMenu(society, nil, options) end}

		lib.registerContext({
			id = 'society_8',
			title = 'Salary Management', 
			options = elements
		})
		lib.showContext('society_8')
	end, society)
end

function OpenManageGradesMenu(society, options)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		if not job then
			return
		end

		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			elements[#elements+1] = {
				icon = "fas fa-wallet", 
				title = ('%s'):format(gradeLabel), 
				value = job.grades[i].grade,
				onSelect = function()
					local input = lib.inputDialog('', {'Set Grade Label'})
					if not input then return end

					if input[1] then
						local label = tostring(input[1])
	
						ESX.TriggerServerCallback('esx_society:setJobLabel', function()
							OpenManageGradesMenu(society, options)
						end, society, job.grades[i].grade, label)
					else
						ZenDevelopment.SendNotify('Invalid Input!', 'error')
						OpenManageGradesMenu(society, options)
					end
				end
			}
		end
			
		elements[#elements+1] = {icon = "fas fa-arrow-left", title = "Return", onSelect = function() OpenBossMenu(society, nil, options) end}

		lib.registerContext({
			id = 'society_9',
			title = 'Rank Management', 
			options = elements
		})
		lib.showContext('society_9')
	end, society)
end

AddEventHandler('esx_society:openBossMenu', function(society, close, options)
	OpenBossMenu(society, close, options)
end)
