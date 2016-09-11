delete_dir_fiotest:
  cmd.run:
    - name: rm -Rf /root/fiotest

create_dir_fiotest:
  cmd.run:
    - name: mkdir /root/fiotest

create_fiotest_file:
  file.managed:
    - name: /root/fiotest.fio
    - contents: |
        [global]
        name=randwrite
        ioengine=libaio
        iodepth=64
        size=4G
        runtime=120
        numjobs=15
        direct=1
        per_job_logs=0
        directory=/root/fiotest/        

        [randwrite-fio-4k]
        bs=4k
        rw=randwrite
        write_bw_log=/root/fiotest/4k-randwrite.results
        write_iops_log=/root/fiotest/4k-randwrite.results
        write_lat_log=/root/fiotest/4k-randwrite.results
    - require:
      - cmd: create_dir_fiotest

running_fio_test:
  cmd.run:
    - name: fio /root/fiotest.fio