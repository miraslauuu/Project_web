<?php

header('Access-Control-Allow-Origin:*');
header('<Content-Type: application/json');
header('Access-Control-Allow-Metod: POST');
header('Access-Control-Allow-Heagers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Request-With');

require '../db_php_files/db_config.php'; 

echo "PHP works";

// Sprawdzenie, czy dane zostały przesłane poprawnie
// if (isset($_POST['uname']) && isset($_POST['psw'])) {
//     $username = $_POST['uname'];
//     $password = $_POST['psw'];
//     try {
//         // Ustawienie połączenia
//         $conn = new PDO("sqlsrv:Server=LAPTOP-BJSNAIAH;Database=SVO_DB_PROJECT_FINAL_VERSION", "anhelina", "Hfge!0406");
//         $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

//         // Przygotowanie procedury przechowywanej
//         $stmt = $conn->prepare("EXEC UserLogInValidation :username, :password, @result OUTPUT");

//         // Ustawienie parametrów
//         $stmt->bindParam(':username', $username, PDO::PARAM_STR);
//         $stmt->bindParam(':password', $password, PDO::PARAM_STR);

//         // Ustawienie zmiennej wyjściowej
//         $result = 0;
//         $stmt->bindParam('@result', $result, PDO::PARAM_INT, 1);

//         // Wykonanie procedury 

//         $stmt->execute();

//         // Sprawdzenie wyniku
//         if ($result == 0) {
//             echo "Zalogowano pomyślnie.";
//         } elseif ($result == 1) {
//             echo "Użytkownik nie istnieje.";
//         } elseif ($result == 2) {
//             echo "Błędne hasło.";
//         } else {
//             echo "Nieoczekiwany wynik z procedury.";
//         }

//     } catch (PDOException $e) {
//         echo "Błąd połączenia z bazą danych: " . $e->getMessage();
//     }
// } else {
//     echo "Nie podano nazwy użytkownika lub hasła.";
// }

// // Zamknięcie połączenia z bazą danych
// $conn = null;




