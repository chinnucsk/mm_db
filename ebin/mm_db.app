{application,mm_db,
             [{description,"DB Tools App"},
              {vsn,"0.0.1"},
              {registered,[]},
              {applications,[kernel,stdlib,mm_config,epgsql]},
              {mod,{mm_db_app,[]}},
              {env,[]},
              {modules,[db,db_worker,mm_db,mm_db_app]}]}.
