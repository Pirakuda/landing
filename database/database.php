<?php

class Database {
    private ?PDO $db = null;
    private string $servername;
    private string $username;
    private string $password;
    private string $dbname;

    public function __construct(string $servername, string $username, string $password, string $dbname) {
        $this->servername = $servername;
        $this->username = $username;
        $this->password = $password;
        $this->dbname = $dbname;
        $this->connect();
    }

    public function getConnection(): ?PDO {
        return $this->db;
    }

    private function connect(): void {
        $options = [
            PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8mb4',
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        ];

        try {
            $this->db = new PDO(
                "mysql:host={$this->servername};dbname={$this->dbname}",
                $this->username,
                $this->password,
                $options
            );
        } catch (PDOException $e) {
            throw new Exception('Database connection failed: ' . $e->getMessage());
        }
    }

    public function query(string $query, array $params = []): PDOStatement {
        try {
            $stmt = $this->db->prepare($query);
            $stmt->execute($params);
            return $stmt;
        } catch (PDOException $e) {
            throw new Exception('Database query error: ' . $e->getMessage());
        }
    }

    public function fetch(string $query, array $params = []): array|false {
        return $this->query($query, $params)->fetch();
    }

    public function fetchAll(string $query, array $params = []): array {
        return $this->query($query, $params)->fetchAll();
    }

    public function beginTransaction(): void {
        $this->db->beginTransaction();
    }

    public function commit(): void {
        $this->db->commit();
    }

    public function rollBack(): void {
        $this->db->rollBack();
    }

    public function close(): void {
        $this->db = null;
    }

    // Новый метод для получения последнего вставленного ID
    public function lastInsertId(): string | false {
        return $this->db->lastInsertId();
    }

    // Метод для переподключения (если нужно)
    public function reconnect(): void {
        $this->close();
        $this->connect();
    }
}

// class Database {
//     private $db;

//     public function __construct($servername, $username, $password, $dbname) {
//         $options = array(
//             PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8mb4',
//             PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
//             PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
//         );

//         try {
//             $this->db = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password, $options);
//         } catch (PDOException $e) {
//             throw new Exception('Datenbankverbindung fehlgeschlagen: ' . $e->getMessage());
//         }
//     }

//     public function query($query, $params = array()) {
//         try {
//             $stmt = $this->db->prepare($query);
//             $stmt->execute($params);
//             return $stmt;
//         } catch (PDOException $e) {
//             throw new Exception('Database query error: ' . $e->getMessage());
//         }
//     }

//     public function fetch($query, $params = array()) {
//         $stmt = $this->query($query, $params);
//         return $stmt->fetch();
//     }

//     public function fetchAll($query, $params = array()) {
//         $stmt = $this->query($query, $params);
//         return $stmt->fetchAll();
//     }

//     public function close() {
//         $this->db = null;
//     }
// }