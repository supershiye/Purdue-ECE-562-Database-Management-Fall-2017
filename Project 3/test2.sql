                        UPDATE query_10 qq
                            SET
                                qq.cflag = 14
                        WHERE
                            qq.patient_name = 'A'
                            AND   qq.icost = 5681.5
--                            AND   qq.patient_type = otype
                            AND   qq.cflag = 90;