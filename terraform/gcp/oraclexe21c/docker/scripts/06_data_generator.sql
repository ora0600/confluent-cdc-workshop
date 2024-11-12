-- generate orders

create or replace procedure produce_orders
authid current_user
as
 l_insert long;
 begin
 -- insert for 5 hours data into orders, every 5 seconds
 for x in 1..3600 loop
     insert into orders (customer_id, status, salesman_id ,order_date) values (dbms_random.value(1,300),'Pending',dbms_random.value(1,100),sysdate);
     commit;
     DBMS_LOCK.sleep(seconds => 5); -- 5 seconds
 END LOOP;
end;
/
