<?php
header('Content-Type: application/json');
include "./db.php";

$id = (int) $_POST['id'];
$stmt = $db->prepare("DELETE FROM mahasiswa WHERE id = ?");
$result = $stmt->execute([$id]);

echo json_encode([
'id' => $id,
'success' => $result
]);

?>