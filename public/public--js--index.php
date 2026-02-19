<?php
if ($_SERVER['REQUEST_URI'] !== '/bots/sales_bot.php') {
    header("Location: /");
    exit();
}
