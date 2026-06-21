<div class="modal fade" id="invoiceDetailModal" tabindex="-1" aria-labelledby="invoiceDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-0 pb-0">
                <div>
                    <h5 class="modal-title fw-bold" id="invoiceDetailModalLabel">Invoice Details</h5>
                    <p class="text-muted small mb-0" id="invoiceDetailSubtitle">Loading...</p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <button type="button" class="btn btn-sm btn-outline-dark rounded-pill d-none" id="invoicePrintBtn"
                            onclick="printCurrentInvoice()">
                        <i class="bi bi-printer me-1"></i>Print
                    </button>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
            </div>
            <div class="modal-body pt-3">
                <div id="invoiceDetailLoading" class="text-center py-5 text-muted">
                    <div class="spinner-border spinner-border-sm me-2" role="status"></div>Loading invoice...
                </div>
                <div id="invoiceDetailContent" style="display:none;">
                    <div class="bg-light rounded-4 p-3 mb-4">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="text-muted small text-uppercase fw-bold">Payment</div>
                                <div class="fw-semibold" id="detailPaymentStatus">—</div>
                                <div class="text-muted small" id="detailPaymentMethod">—</div>
                            </div>
                            <div class="col-md-6">
                                <div class="text-muted small text-uppercase fw-bold">Booking Status</div>
                                <div class="fw-semibold" id="detailBookingStatus">—</div>
                                <div class="text-muted small" id="detailInvoiceDate">—</div>
                            </div>
                        </div>
                        <hr class="my-3">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted small">Subtotal</span>
                            <span id="detailSubTotal">0 VND</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2 text-success d-none" id="detailDiscountRow">
                            <span class="small" id="detailDiscountLabel">Discount</span>
                            <span id="detailDiscountAmount">0 VND</span>
                        </div>
                        <div class="d-flex justify-content-between fw-bold fs-5">
                            <span>Total</span>
                            <span id="detailFinalAmount">0 VND</span>
                        </div>
                        <div class="text-muted small mt-2" id="detailNote"></div>
                    </div>

                    <h6 class="fw-bold mb-3"><i class="bi bi-list-check me-2 text-muted"></i>Bookings in this invoice</h6>
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead class="table-light text-muted small text-uppercase">
                                <tr>
                                    <th>Booking</th>
                                    <th>Service</th>
                                    <th>Vehicle</th>
                                    <th>Schedule</th>
                                    <th>Bay</th>
                                    <th class="text-end">Line price</th>
                                    <th class="text-center">Status</th>
                                    <th class="text-end d-none" id="detailAdminActionCol">Action</th>
                                </tr>
                            </thead>
                            <tbody id="detailBookingsBody"></tbody>
                        </table>
                    </div>
                </div>
                <div id="invoiceDetailError" class="alert alert-danger d-none mb-0"></div>
            </div>
        </div>
    </div>
</div>

<script>
    var currentInvoiceId = null;

    function formatVnd(amount) {
        return new Intl.NumberFormat('vi-VN').format(amount) + ' VND';
    }

    function printInvoice(invoiceId) {
        var printBase = window.invoicePrintBase || 'InvoicePrint';
        var sep = printBase.indexOf('?') >= 0 ? '&' : '?';
        window.open(printBase + sep + 'invoiceId=' + invoiceId, '_blank', 'width=900,height=700');
    }

    function printCurrentInvoice() {
        if (currentInvoiceId) {
            printInvoice(currentInvoiceId);
        }
    }

    function buildAdminBookingAction(status, bookingId) {
        var scope = window.adminInvoiceScope || 'all';
        var scopeField = '<input type="hidden" name="scope" value="' + scope + '">';
        var s = (status || '').toLowerCase();
        if (s === 'confirmed') {
            return '<form action="MainController?action=process_booking" method="POST" class="d-inline m-0">'
                + scopeField
                + '<input type="hidden" name="actionAdmin" value="checkin">'
                + '<input type="hidden" name="id" value="' + bookingId + '">'
                + '<button type="submit" class="btn btn-sm btn-dark rounded-pill px-2 py-1">Check In</button>'
                + '</form>';
        }
        if (s === 'inprogress') {
            return '<form action="MainController?action=process_booking" method="POST" class="d-inline m-0">'
                + scopeField
                + '<input type="hidden" name="actionAdmin" value="checkout">'
                + '<input type="hidden" name="id" value="' + bookingId + '">'
                + '<button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-2 py-1">Check Out</button>'
                + '</form>';
        }
        if (s === 'pending') {
            return '<span class="text-muted small">Awaiting payment</span>';
        }
        if (s === 'completed') {
            return '<span class="text-success small">Done</span>';
        }
        return '<span class="text-muted small">—</span>';
    }

    function openInvoiceDetail(detailUrl, invoiceId) {
        currentInvoiceId = invoiceId;
        var modalEl = document.getElementById('invoiceDetailModal');
        var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
        var loading = document.getElementById('invoiceDetailLoading');
        var content = document.getElementById('invoiceDetailContent');
        var error = document.getElementById('invoiceDetailError');
        var subtitle = document.getElementById('invoiceDetailSubtitle');
        var bookingsBody = document.getElementById('detailBookingsBody');
        var printBtn = document.getElementById('invoicePrintBtn');
        var adminCol = document.getElementById('detailAdminActionCol');
        var isAdmin = window.invoiceHistoryAdminMode === true;

        subtitle.textContent = 'Invoice #' + invoiceId;
        loading.style.display = '';
        content.style.display = 'none';
        error.classList.add('d-none');
        bookingsBody.innerHTML = '';
        printBtn.classList.remove('d-none');
        if (adminCol) {
            if (isAdmin) {
                adminCol.classList.remove('d-none');
            } else {
                adminCol.classList.add('d-none');
            }
        }
        modal.show();

        var detailSep = detailUrl.indexOf('?') >= 0 ? '&' : '?';
        var detailAction = detailUrl.indexOf('MainController') >= 0 ? 'op=detail' : 'action=detail';
        fetch(detailUrl + detailSep + detailAction + '&invoiceId=' + invoiceId)
            .then(function (res) { return res.json(); })
            .then(function (data) {
                loading.style.display = 'none';
                if (!data.success || !data.invoice) {
                    error.textContent = data.message || 'Could not load invoice details.';
                    error.classList.remove('d-none');
                    return;
                }
                var inv = data.invoice;
                document.getElementById('detailPaymentStatus').textContent = inv.paymentStatus || '—';
                document.getElementById('detailPaymentMethod').textContent = inv.paymentMethod ? ('Method: ' + inv.paymentMethod) : 'Method: —';
                document.getElementById('detailBookingStatus').textContent = inv.bookingStatus || '—';
                document.getElementById('detailInvoiceDate').textContent = inv.invoiceDate ? ('Created: ' + inv.invoiceDate) : '';
                document.getElementById('detailSubTotal').textContent = formatVnd(inv.subTotal || 0);
                document.getElementById('detailFinalAmount').textContent = formatVnd(inv.finalAmount || 0);

                var discountRow = document.getElementById('detailDiscountRow');
                if (inv.discountAmount && inv.discountAmount > 0) {
                    discountRow.classList.remove('d-none');
                    discountRow.classList.add('d-flex');
                    document.getElementById('detailDiscountLabel').textContent = inv.promotionName
                        ? ('Discount (' + inv.promotionName + ')')
                        : 'Discount';
                    document.getElementById('detailDiscountAmount').textContent = '-' + formatVnd(inv.discountAmount);
                } else {
                    discountRow.classList.add('d-none');
                    discountRow.classList.remove('d-flex');
                }

                var noteEl = document.getElementById('detailNote');
                if (inv.note) {
                    noteEl.textContent = 'Note: ' + inv.note;
                    noteEl.style.display = '';
                } else {
                    noteEl.style.display = 'none';
                }

                (inv.bookings || []).forEach(function (b) {
                    var tr = document.createElement('tr');
                    var adminCell = isAdmin
                        ? '<td class="text-end text-nowrap">' + buildAdminBookingAction(b.status, b.bookingId) + '</td>'
                        : '';
                    tr.innerHTML =
                        '<td class="font-monospace small text-muted">#' + b.bookingId + '</td>' +
                        '<td><div class="fw-semibold">' + (b.service || '') + '</div><div class="text-muted small">' + (b.durationAtOrder || 0) + ' min</div></td>' +
                        '<td><div class="fw-semibold">' + (b.vehicleName || '') + '</div><span class="badge bg-light text-dark border font-monospace small">' + (b.licensePlate || '') + '</span></td>' +
                        '<td><div class="fw-semibold">' + (b.scheduleStart || '') + ' - ' + (b.scheduleEnd || '') + '</div><div class="text-muted small">' + (b.scheduleDate || '') + '</div></td>' +
                        '<td><span class="badge bg-light text-dark border">' + (b.bayName || 'N/A') + '</span></td>' +
                        '<td class="text-end fw-semibold">' + formatVnd(b.priceAtOrder || 0) + '</td>' +
                        '<td class="text-center"><span class="badge bg-light text-dark border rounded-pill px-3 py-2">' + (b.status || '') + '</span></td>' +
                        adminCell;
                    bookingsBody.appendChild(tr);
                });

                content.style.display = '';
            })
            .catch(function () {
                loading.style.display = 'none';
                error.textContent = 'Could not load invoice details.';
                error.classList.remove('d-none');
            });
    }
</script>