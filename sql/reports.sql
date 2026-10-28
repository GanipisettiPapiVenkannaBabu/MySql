
-- Online Movie Ticket Booking System
-- SQL Reports

-- 1. Display complete booking details
SELECT
    b.booking_id,
    c.customer_name,
    m.movie_title,
    t.theatre_name,
    ms.show_date,
    ms.show_time,
    b.seats_booked,
    b.total_amount,
    b.booking_status
FROM Booking b
JOIN Customer c ON b.customer_id = c.customer_id
JOIN Movie_Show ms ON b.show_id = ms.show_id
JOIN Movie m ON ms.movie_id = m.movie_id
JOIN Screen sc ON ms.screen_id = sc.screen_id
JOIN Theatre t ON sc.theatre_id = t.theatre_id;

-- 2. Display movies by rating
SELECT movie_id, movie_title, movie_stars
FROM Movie
ORDER BY movie_stars DESC;

-- 3. Calculate confirmed booking revenue
SELECT SUM(total_amount) AS confirmed_revenue
FROM Booking
WHERE booking_status = 'Confirmed';

-- 4. Count bookings by status
SELECT booking_status, COUNT(*) AS total_bookings
FROM Booking
GROUP BY booking_status;

-- 5. Check for duplicate seat assignments
SELECT seat_id, COUNT(*) AS assignment_count
FROM Booking_Seat
GROUP BY seat_id
HAVING COUNT(*) > 1;

-- 6. Display seat assignments with booking details
SELECT
    bs.booking_seat_id,
    bs.booking_id,
    b.show_id,
    bs.seat_id,
    s.seat_number
FROM Booking_Seat bs
JOIN Booking b ON bs.booking_id = b.booking_id
JOIN Seat s ON bs.seat_id = s.seat_id
ORDER BY bs.booking_id, s.seat_number;
