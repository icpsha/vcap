class JobManager
  [NATS, CF, CCDB,CD].each do |job|
    task job.to_sym do
      install(job)
    end
  end

  [CC, HM].each do |job|
    task job.to_sym => [CF.to_sym, NATS.to_sym, CCDB.to_sym] do
      install(job)
    end
  end

  [ROUTER, DEA].each do |job|
    task job.to_sym => [CF.to_sym, NATS.to_sym] do
      install(job)
    end
  end

  SERVICES_NODE.each do |job|
    task job.to_sym => [CF.to_sym, NATS.to_sym] do
      install(job)
    end
  end

  SERVICES_GATEWAY.each do |job|
    task job.to_sym => [CF.to_sym, CC.to_sym, NATS.to_sym] do
      install(job)
    end
  end

  all_jobs = []
  JOBS.each do |job|
    all_jobs << job.to_sym if job != ALL && job != SAPALL
  end
  
  sapall_jobs = []
  SAPJOBS.each do |job|
    sapall_jobs << job.to_sym
  end
  task SAPALL.to_sym => sapall_jobs
  task ALL.to_sym => all_jobs
  task :default => ALL.to_sym
end
