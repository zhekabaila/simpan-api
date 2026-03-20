<?php

namespace App\Helpers;

use Illuminate\Pagination\LengthAwarePaginator;

class PaginationHelper
{
    public static function format(LengthAwarePaginator $paginator, $resourceCollection = null, $additionalData = []): array
    {
        $data = $resourceCollection ?? $paginator->items();

        return [
            'data'  => $data,
            'limit' => $paginator->perPage(),
            'page'  => $paginator->currentPage(),
            'size'  => $paginator->count(),
            'pages' => $paginator->lastPage(),
            ...$additionalData,
        ];
    }
}
