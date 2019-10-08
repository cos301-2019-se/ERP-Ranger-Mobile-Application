import { TestBed } from '@angular/core/testing';

import { ReportTypeService } from './report-type.service';

describe('ReportTypeService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: ReportTypeService = TestBed.get(ReportTypeService);
    expect(service).toBeTruthy();
  });
});
