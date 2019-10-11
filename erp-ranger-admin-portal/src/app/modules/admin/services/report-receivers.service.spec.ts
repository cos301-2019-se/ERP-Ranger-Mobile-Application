import { TestBed } from '@angular/core/testing';

import { ReportReceiversService } from './report-receivers.service';

describe('ReportReceiversService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: ReportReceiversService = TestBed.get(ReportReceiversService);
    expect(service).toBeTruthy();
  });
});
